#!/usr/bin/env bash

thisfile=`realpath $0`
thisdir="${thisfile%/*}"

v_HOME="$HOME"
v_GIT_EMAIL=""
v_GIT_NAME=""

templated_files=()

read_replace_values() {
	IFS= read -r -e -p 'git e-mail: ' v_GIT_EMAIL
	IFS= read -r -e -p 'git name: ' v_GIT_NAME
}

detect_templated_files() {
	#for each file stored in git (not incluing top level ones)
	while IFS= read -r line;
	do
		#checks if file has a replace pattern inside
		grep -qE '\{\{' "$thisdir/$line"

		if [[ $? -eq 0 ]]; then
			templated_files+=("$thisdir/$line")
		fi
	done < <(git -C "$thisdir" ls-files | grep -E '/')
}

replace_templated_files() {
	script_file=$(mktemp)
	cat <<- EOF >$script_file
s!\\{\\{HOME\\}\\}!$v_HOME!g
s!\\{\\{GIT_EMAIL\\}\\}!$v_GIT_EMAIL!g
s!\\{\\{GIT_NAME\\}\\}!$v_GIT_NAME!g
EOF

	#replaces the templated files inplace
	for tfile in "${templated_files[@]}"; do
		sed -E -f "$script_file" -i "$tfile"
	done
}

read_replace_values
detect_templated_files

echo $'\n*** The following files will go under pattern replacement:'
IFS=$'\n'
echo "${templated_files[*]}"
unset IFS

IFS= read -r -e -p $'\nDoes the above look ok? [y/n]: ' confirmation
if [[ "$confirmation" != 'y' ]]; then
	echo 'Aborting...' 1>&2
	exit 1
fi

replace_templated_files
