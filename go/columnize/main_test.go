package main

import "testing"

func Test_Strip(t *testing.T) {
	o := Strip(" \t a b c")
	if o != "a b c" {
		t.Errorf("Stripping leading spaces incorrect, got: %q, want: %q.", o, "a b c")
	}
	o = Strip("a b c \t ")
	if o != "a b c" {
		t.Errorf("Trailing leading spaces incorrect, got: %q, want: %q.", o, "a b c")
	}
	o = Strip(" \t d e f \t ")
	if o != "d e f" {
		t.Errorf("Trailing and leading spaces incorrect, got: %q, want: %q.", o, "d e f")
	}
	t.Log(o)
}

func Test_Columnize(t *testing.T) {
	o := Columnize("a  b \t  c")
	if o != "a b c" {
		t.Errorf("Removing excess spaces incorrect, got: %q, want: %q.", o, "a b c")
	}
}
