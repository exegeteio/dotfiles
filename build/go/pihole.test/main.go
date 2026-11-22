// pihole.test checks the status of the self-hosted DNS servers.
//
// The tool reads the server list from the PIHOLES environment variable. The
// variable holds server addresses that white space separates. The tool also
// tests the default resolver of the system.
//
// For each server, the tool resolves two names. The name ads.google.com must
// resolve to 0.0.0.0, because the server blocks it. The name www.google.com
// must resolve to any address. The tool prints one line for each server,
// with a check mark for success. A failed line also shows the reason. The
// exit code is 1 if a check fails.
//
// With the -w flag, the tool checks the servers once each second. It draws
// a history bar for each server, in the style of the btop graphs. A tall
// red bar marks a failure. A short green bar marks a success. The newest
// result is at the right. Press Ctrl-C to stop.
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"net"
	"os"
	"os/exec"
	"os/signal"
	"strconv"
	"strings"
	"sync"
	"time"
)

const (
	passMark = "✓"
	failMark = "✗"
	timeout  = 3 * time.Second
)

// Check describes one name to resolve. If Want is empty, any address passes.
// If Want is not empty, the first address of the answer must equal Want.
type Check struct {
	Name string
	Want string
}

// Checks lists the names that the tool resolves on each server.
var Checks = []Check{
	{Name: "ads.google.com", Want: "0.0.0.0"},
	{Name: "www.google.com"},
}

// Lookuper resolves a name to a list of IPv4 addresses.
type Lookuper interface {
	LookupIP(ctx context.Context, network, host string) ([]net.IP, error)
}

// Result holds the outcome of one Check.
type Result struct {
	Check  Check
	Answer string
	Err    error
}

// OK reports if the result satisfies its check.
func (r Result) OK() bool {
	if r.Err != nil {
		return false
	}
	return r.Check.Want == "" || r.Answer == r.Check.Want
}

// Report holds the results of all checks on one server.
type Report struct {
	Server  string
	Results []Result
}

// OK reports if every result in the report passes.
func (r Report) OK() bool {
	for _, res := range r.Results {
		if !res.OK() {
			return false
		}
	}
	return true
}

// Servers splits the value of PIHOLES into a list of server addresses.
func Servers(value string) []string {
	return strings.Fields(value)
}

// NewResolver returns a resolver that sends all queries to one server. If the
// address has no port, the resolver uses port 53.
func NewResolver(server string) *net.Resolver {
	address := server
	if _, _, err := net.SplitHostPort(server); err != nil {
		address = net.JoinHostPort(strings.Trim(server, "[]"), "53")
	}
	dialer := &net.Dialer{Timeout: timeout}
	return &net.Resolver{
		PreferGo: true,
		Dial: func(ctx context.Context, network, _ string) (net.Conn, error) {
			return dialer.DialContext(ctx, network, address)
		},
	}
}

// Run resolves each name in checks with the resolver and returns the report.
func Run(server string, resolver Lookuper, checks []Check) Report {
	report := Report{Server: server}
	for _, check := range checks {
		ctx, cancel := context.WithTimeout(context.Background(), timeout)
		ips, err := resolver.LookupIP(ctx, "ip4", check.Name)
		cancel()
		// Drop the resolver address from the error. It names the system
		// resolver, not the server under test.
		var dnsErr *net.DNSError
		if errors.As(err, &dnsErr) {
			err = errors.New(dnsErr.Err)
		}
		result := Result{Check: check, Err: err}
		if err == nil && len(ips) > 0 {
			result.Answer = ips[0].String()
		} else if err == nil {
			result.Err = fmt.Errorf("no answer")
		}
		report.Results = append(report.Results, result)
	}
	return report
}

// Summary returns the one-line status of a report. A failed line ends with
// the reason for the first failed check.
func Summary(r Report) string {
	if r.OK() {
		return passMark + " " + r.Server
	}
	return failMark + " " + r.Server + " (" + Reason(r) + ")"
}

// Reason describes the first failed result in a report.
func Reason(r Report) string {
	for _, res := range r.Results {
		switch {
		case res.OK():
			continue
		case res.Err != nil:
			return fmt.Sprintf("%s: %v", res.Check.Name, res.Err)
		default:
			return fmt.Sprintf("%s: got %s, want %s", res.Check.Name, res.Answer, res.Check.Want)
		}
	}
	return ""
}

// Bar colors and glyphs for the history graph.
const (
	green    = "\x1b[32m"
	red      = "\x1b[31m"
	reset    = "\x1b[0m"
	passBar  = "▅"
	failBar  = "█"
	interval = time.Second
)

// Bar draws the newest width results of a history. The newest result is at
// the right. If the history is shorter than width, spaces fill the left.
func Bar(history []bool, width int) string {
	if width < 1 {
		return ""
	}
	if len(history) > width {
		history = history[len(history)-width:]
	}
	var b strings.Builder
	b.WriteString(strings.Repeat(" ", width-len(history)))
	for _, ok := range history {
		if ok {
			b.WriteString(green + passBar + reset)
		} else {
			b.WriteString(red + failBar + reset)
		}
	}
	return b.String()
}

// Row draws one line of the watch display: the mark of the newest result,
// the padded server name, and the history bar.
func Row(server string, history []bool, nameWidth, width int) string {
	mark := green + passMark + reset
	if len(history) > 0 && !history[len(history)-1] {
		mark = red + failMark + reset
	}
	pad := strings.Repeat(" ", nameWidth-len([]rune(server)))
	// The mark, two spaces, and the name take the width before the bar.
	return mark + " " + server + pad + " " + Bar(history, width-nameWidth-3)
}

// terminalWidth returns the number of columns of the terminal, or 80 if the
// tool cannot find the number.
func terminalWidth() int {
	cmd := exec.Command("stty", "size")
	cmd.Stdin = os.Stdin
	out, err := cmd.Output()
	if err != nil {
		return 80
	}
	fields := strings.Fields(string(out))
	if len(fields) != 2 {
		return 80
	}
	if n, err := strconv.Atoi(fields[1]); err == nil && n > 0 {
		return n
	}
	return 80
}

// Targets holds the names and resolvers of the servers to check.
type Targets struct {
	Names     []string
	Resolvers []Lookuper
}

// NewTargets builds the targets for the default resolver and each server.
func NewTargets(servers []string) Targets {
	t := Targets{Names: []string{"default"}, Resolvers: []Lookuper{net.DefaultResolver}}
	for _, server := range servers {
		t.Names = append(t.Names, server)
		t.Resolvers = append(t.Resolvers, NewResolver(server))
	}
	return t
}

// Check runs all checks on all targets at the same time. Each goroutine
// writes one slot of the result.
func (t Targets) Check() []Report {
	reports := make([]Report, len(t.Names))
	var wg sync.WaitGroup
	for i := range t.Names {
		wg.Add(1)
		go func() {
			defer wg.Done()
			reports[i] = Run(t.Names[i], t.Resolvers[i], Checks)
		}()
	}
	wg.Wait()
	return reports
}

// watch checks the targets each interval and redraws the history until the
// context ends.
func watch(ctx context.Context, t Targets) {
	history := make([][]bool, len(t.Names))
	nameWidth := 0
	for _, name := range t.Names {
		nameWidth = max(nameWidth, len([]rune(name)))
	}

	// Hide the cursor and clear the screen. Restore the cursor on exit.
	fmt.Print("\x1b[?25l\x1b[2J")
	defer fmt.Print("\x1b[?25h\n")

	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		for i, r := range t.Check() {
			history[i] = append(history[i], r.OK())
		}
		width := terminalWidth()
		var b strings.Builder
		b.WriteString("\x1b[H")
		for i, name := range t.Names {
			// Keep only the results that fit on the screen.
			if len(history[i]) > width {
				history[i] = history[i][len(history[i])-width:]
			}
			b.WriteString(Row(name, history[i], nameWidth, width) + "\x1b[K\n")
		}
		fmt.Print(b.String())

		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
		}
	}
}

func main() {
	watchFlag := flag.Bool("w", false, "check the servers each second and show a history")
	flag.Parse()
	targets := NewTargets(Servers(os.Getenv("PIHOLES")))

	if *watchFlag {
		ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
		defer stop()
		watch(ctx, targets)
		return
	}

	failed := false
	for _, r := range targets.Check() {
		fmt.Println(Summary(r))
		failed = failed || !r.OK()
	}
	if failed {
		os.Exit(1)
	}
}
