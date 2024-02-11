package main

import (
	"fmt"
	"os"

	"golang.org/x/term"
)

func main() {
	// check if the user has provided a prompt as the first cli argument
	var prompt string
	prompt = getPrompt(prompt)

	// Print the prompt to the console and get a response.
	print(prompt + " (y/n): ")

	// Read the response from the console without the user needing to press enter.
	response, err := readChar()
	if err != nil {
		panic(err)
	}

	// Print response and a newline to indicate we received the input.
	fmt.Println(string(response))

	// Check if the response starts with a y or Y.
	if response == 'y' || response == 'Y' {
		os.Exit(0)
	} else {
		os.Exit(1)
	}
}

func getPrompt(prompt string) string {
	if len(os.Args) > 1 {
		prompt = os.Args[1]
	} else {
		prompt = "Continue?"
	}
	return prompt
}

func readChar() (c byte, err error) {
	// switch stdin into 'raw' mode
	oldState, err := term.MakeRaw(int(os.Stdin.Fd()))
	if err != nil {
		return 0, err
	}

	// Be sure we switch back!
	defer func(fd int, oldState *term.State) {
		err := term.Restore(fd, oldState)
		if err != nil {
			panic(err)
		}
	}(int(os.Stdin.Fd()), oldState)

	b := make([]byte, 1)
	_, err = os.Stdin.Read(b)
	if err != nil {
		return 0, err
	}
	return b[0], nil
}
