package main

import (
	"fmt"
	"net/url"
	"os"
)

func main() {
	for _, a := range os.Args[1:] {
		fmt.Println(url.QueryEscape(a))
	}
}
