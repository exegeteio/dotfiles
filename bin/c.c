#!/usr/bin/env bash
# Stolen from rwxrob:  github.com/rwxrob/dot

tmux -L stream send -t '{marked}' "/c" Enter