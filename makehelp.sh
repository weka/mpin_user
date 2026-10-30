#!/bin/bash
#
# This is a make helper script that finds the proper LINUX_HEADERS_PREFIX
# Makefile usage: makehelp.sh $(LINUXINCLUDE)
#	   $(LINUXINCLUDE) as defined by make
# Output on stdout the correct LINUX_HEADERS_PREFIX

_extract_dir_names()
{
	local p

	for p in "$@"; do
		if [[ $p == \-I*  ]]; then
			printf '%s\n' "${p#-I}"
		fi
	done
}

find_linux_headers()
{
	local f bn

	while IFS= read -r f; do
		bn="$(basename "$f")"
		if [ -e "$f/linux/fs.h" ] && [ "$bn" != "uapi" ] && [ "$bn" != "drm-backport" ]; then
			printf '%s\n' "$f"
			return 0
		fi
	done < <(_extract_dir_names "$@")

	return 17
}

__LINUXINCLUDE="$@"

LINUX_HEADERS_PREFIX="$(find_linux_headers "$@")"
if [ -z "$LINUX_HEADERS_PREFIX" ]; then
	echo "makehelp failed [$__LINUXINCLUDE]"
	exit 17
fi

printf '%s\n' "$LINUX_HEADERS_PREFIX"
exit 0
