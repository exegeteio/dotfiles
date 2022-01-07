package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func argsOrStdin() []string {
	var args []string
	stat, _ := os.Stdin.Stat()
	if (stat.Mode() & os.ModeCharDevice) == 0 {
		scanner := bufio.NewScanner(os.Stdin)
		for scanner.Scan() {
			args = append(args, scanner.Text())
		}
	} else {
		args = os.Args[1:]
	}
	return args
}

func main() {
	// Don't care if this errors.
	for _, f := range argsOrStdin() {
		fmt.Println(f)
		parts := strings.Split(f, ":")
		if len(parts) == 1 {
			// No line number.
			fmt.Println(parts[0])
		} else {
			if line, err := strconv.Atoi(parts[1]); err == nil {
				fmt.Printf("+%d %s\n", line, parts[0])
			}
		}
	}
}
