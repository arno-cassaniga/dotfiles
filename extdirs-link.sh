#!/usr/bin/env bash

unset is_undo
unset is_print_dirs
unset is_dirs_from_stdin
unset is_dry_run

dirlist=(
	"./Calibre Library:$HOME/Calibre Library"
	"./.cargo:$HOME/.cargo"
	"./.config/chromium:$HOME/.config/chromium"
	"./Documents:$HOME/Documents"
	"./Downloads:$HOME/Downloads"
	"./exercism:$HOME/exercism"
	"./go-workspace:$HOME/go"
	"./.mozilla:$HOME/.mozilla"
	"./.nvm:$HOME/.nvm"
	"./.npm:$HOME/.npm"
	"./.pnpm-store:$HOME/.pnpm-store"
	"./repos:$HOME/repos"
	"./.rustup:$HOME/.rustup"
	"./vbox-vms:$HOME/vbox-vms"
)

make_link() {
	local dir_from="$(realpath "$1")"
	local dir_to="$2"

	#is it already a symlink?
	if [[ -L "$dir_to" ]]; then
		echo "[ALREADY LINKED] $dir_to"
	#already exists?
	elif [[ -e "$dir_to" ]]; then
		printf "\n\n***** [ALREADY EXISTS] $dir_to\n\n"
	#does not exist: we should link it
	else
		if [[ ! "$is_dry_run" == "y" ]]; then
			ln -s "$dir_from" "$dir_to"
		fi
		echo "[LINKED] $dir_to -> $dir_from"
	fi
}

undo_link() {
	local dir_from="$1"
	local dir_to="$2"

	#checks if it is a symlink
	if [[ -L "$dir_to" ]]; then
		if [[ ! "$is_dry_run" == "y" ]]; then
			rm "$dir_to"
		fi
		echo "[UNLINKED] $dir_to"
	else
		echo "[NOT A LINK] $dir_to"
	fi
}

handle_link_item() {
	local dir_from="$1"
	local dir_to="$2"

	if [[ "$is_undo" == "y" ]]; then
		undo_link "$dir_from" "$dir_to"
	else
		make_link "$dir_from" "$dir_to"
	fi
}

while getopts 'uprd' opt ; do
	case "$opt" in
		u)
			is_undo=y
			;;
		p)
			is_print_dirs=y
			;;
		r)
			is_dirs_from_stdin=y
			;;
		d)
			is_dry_run=y
			;;
	esac
done

##### print mode
if [[ "$is_print_dirs" == "y" ]]; then
	for i in ${!dirlist[@]}; do
		echo ${dirlist[$i]}
	done
	exit 0
fi

if [[ "$is_dry_run" == "y" ]]; then
	echo '*** Dry-run mode is active so nothing will actually happen ***'
	echo '--------------------------'
fi

##### read from custom list given in stdin
if [[ "$is_dirs_from_stdin" == "y" ]]; then
	while IFS=":" read -r dir_from dir_to ; do
		handle_link_item "$dir_from" "$dir_to"
	done
	exit 0
fi

##### use full array baked in this script
for i in ${!dirlist[@]}; do
	IFS=":" read -r dir_from dir_to <<< "${dirlist[$i]}"

	handle_link_item "$dir_from" "$dir_to"
done

