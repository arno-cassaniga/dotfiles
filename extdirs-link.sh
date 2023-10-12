#!/usr/bin/env bash

unset is_undo
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
		ln -s "$dir_from" "$dir_to"
		echo "[LINKED] $dir_to -> $dir_from"
	fi
}

undo_link() {
	local dir_from="$1"
	local dir_to="$2"

	#checks if it is a symlink
	if [[ -L "$dir_to" ]]; then
		rm "$dir_to"
		echo "[UNLINKED] $dir_to"
	else
		echo "[NOT A LINK] $dir_to"
	fi
}

while getopts 'u' opt ; do
	case "$opt" in
		u)
			is_undo=y
			;;
	esac
done

for i in ${!dirlist[@]}; do
	IFS=":" read -r dir_from dir_to <<< "${dirlist[$i]}"

	if [[ "$is_undo" == "y" ]]; then
		undo_link "$dir_from" "$dir_to"
	else
		make_link "$dir_from" "$dir_to"
	fi
done

