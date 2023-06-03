#!/usr/bin/env bash
set -e

source_path="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
os=$(uname)

cd "$source_path"

./dotfiles.sh
./brew.sh
./build.sh
[ "$os" == "Linux" ] && sudo ./linux.sh

installer="$source_path/install/$os.sh"
[[ -x "$installer" ]] && bash "$installer"

cd -
