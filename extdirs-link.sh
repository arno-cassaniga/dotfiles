#!/usr/bin/env bash

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

for i in ${!dirlist[@]}; do
	IFS=":" read -r dir_from dir_to <<< "${dirlist[$i]}"

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
done

