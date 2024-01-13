#!/usr/bin/env bash

for i in build/*; do
  if [ -x "$i/build" ]; then
    echo "$i/build"
    (
      cd "./$i"
      ./build
    )
  fi
done

