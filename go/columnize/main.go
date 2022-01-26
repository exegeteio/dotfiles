package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	// Read lines from STDIN.
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		// Strip and remove excess    spaces.
		fmt.Println(Strip(Columnize(scanner.Text())))
	}

	if scanner.Err() != nil {
		// Should never fail to read from stdin.
		panic(scanner.Err())
	}
}

func Strip(str string) string {
	return strings.TrimSpace(str)
}

func Columnize(str string) string {
	return strings.Join(strings.Fields(str), " ")
}
