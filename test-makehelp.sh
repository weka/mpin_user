#!/bin/bash

set -eu

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf -- "$test_dir"' EXIT

header_dir="$test_dir/include"
mkdir -p "$header_dir/linux"
touch "$header_dir/linux/fs.h"

output="$("$script_dir/makehelp.sh" "-I$header_dir" "-I$header_dir")"
if [ "$output" != "$header_dir" ]; then
	printf 'expected one header directory, got: %s\n' "$output" >&2
	exit 1
fi

if "$script_dir/makehelp.sh" "-I$test_dir/missing" >/dev/null 2>&1; then
	echo 'expected missing headers to fail' >&2
	exit 1
fi
