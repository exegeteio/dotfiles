package main

import (
	"context"
	"errors"
	"net"
	"reflect"
	"testing"
)

// fakeResolver returns a fixed answer for each name.
type fakeResolver map[string][]net.IP

func (f fakeResolver) LookupIP(_ context.Context, _, host string) ([]net.IP, error) {
	ips, ok := f[host]
	if !ok {
		return nil, errors.New("no such host")
	}
	return ips, nil
}

func Test_Servers(t *testing.T) {
	got := Servers(" 10.0.0.1  10.0.0.2\t10.0.0.3\n")
	want := []string{"10.0.0.1", "10.0.0.2", "10.0.0.3"}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("Servers incorrect, got: %q, want: %q.", got, want)
	}
	if got := Servers(""); len(got) != 0 {
		t.Errorf("Empty value should give no servers, got: %q.", got)
	}
}

func Test_Run_Pass(t *testing.T) {
	r := fakeResolver{
		"ads.google.com": {net.ParseIP("0.0.0.0")},
		"www.google.com": {net.ParseIP("142.250.1.1")},
	}
	report := Run("good", r, Checks)
	if !report.OK() {
		t.Errorf("Report should pass, got: %s", Summary(report))
	}
	if got := Summary(report); got != "✓ good" {
		t.Errorf("Summary incorrect, got: %q.", got)
	}
}

func Test_Run_AdsNotBlocked(t *testing.T) {
	r := fakeResolver{
		"ads.google.com": {net.ParseIP("142.250.1.2")},
		"www.google.com": {net.ParseIP("142.250.1.1")},
	}
	report := Run("open", r, Checks)
	if report.OK() {
		t.Error("Report should fail when ads.google.com is not 0.0.0.0.")
	}
	if got := Summary(report); got != "✗ open (ads.google.com: got 142.250.1.2, want 0.0.0.0)" {
		t.Errorf("Summary incorrect, got: %q.", got)
	}
}

func Test_Run_Failure(t *testing.T) {
	r := fakeResolver{"ads.google.com": {net.ParseIP("0.0.0.0")}}
	if Run("down", r, Checks).OK() {
		t.Error("Report should fail when www.google.com does not resolve.")
	}
	empty := fakeResolver{
		"ads.google.com": {net.ParseIP("0.0.0.0")},
		"www.google.com": {},
	}
	if Run("empty", empty, Checks).OK() {
		t.Error("Report should fail when the answer has no address.")
	}
}

func Test_Bar(t *testing.T) {
	got := Bar([]bool{true, false}, 4)
	want := "  " + green + passBar + reset + red + failBar + reset
	if got != want {
		t.Errorf("Bar incorrect, got: %q, want: %q.", got, want)
	}
	// A long history keeps only the newest results.
	got = Bar([]bool{false, true, true}, 2)
	want = green + passBar + reset + green + passBar + reset
	if got != want {
		t.Errorf("Bar should trim old results, got: %q, want: %q.", got, want)
	}
	if got := Bar([]bool{true}, 0); got != "" {
		t.Errorf("Bar with no width should be empty, got: %q.", got)
	}
}

func Test_Row(t *testing.T) {
	got := Row("a", []bool{true, false}, 3, 12)
	want := red + failMark + reset + " a   " + Bar([]bool{true, false}, 6)
	if got != want {
		t.Errorf("Row incorrect, got: %q, want: %q.", got, want)
	}
}
