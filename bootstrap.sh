#!/usr/bin/sh

get_pkgs() {

	echo "Validating package list..."
	while read -r package; do
		if [[ -z "$package" ]]; then
			continue
		fi
		echo $package
		if ! yay -Ss "^$package$" >/dev/null; then
			echo "ERROR: Package '$package' not found. Please check your list and spelling."
			exit 1
		fi
	done <minimal_packages.txt

	echo "Package list validation successful."

	echo "Installing all packages..."
	yay -S --needed --noconfirm - <minimal_packages.txt
}

clone_powerlevel10k() {
	echo "Cloning powerlevel10k zsh theme..."
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
}

stow_dir() {
	echo "Stowing..."
}

main() {
	if ! which yay >/dev/null; then
		echo "yay is not installed, installing..."
		sudo pacman -S --needed git base-devel
		cd /tmp
		git clone https://aur.archlinux.org/yay.git /tmp/yay
		cd yay
		makepkg -si
	fi
	get_pkgs
	if ! which zsh >/dev/null; then
		echo "Something went worng with the zsh installation"
		echo "Since we uses oh-my-zsh, the installation will be aborted..."
		sleep 1
		exit 1
	fi
	chsh -s /usr/bin/zsh
	cd ~/dotfiles
	stow_dir
}
main
