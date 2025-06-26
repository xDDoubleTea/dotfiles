#/usr/bin/sh

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

copy_ohmyzsh_theme() {
	cp -r ~/dotfiles/.oh-my-zsh-custom/powerlevel10k/ ./.oh-my-zsh/custom/themes/
	cp ~/dotfiles/.oh-my-zsh-custom/alias.zsh ~/.oh-my-zsh/custom/alias.zsh
}

stow_dir() {

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
	chsh -s /usr/bin/zsh
	get_pkgs
	cd dotfiles
	copy_ohmyzsh_theme
	stow_dir
}
main
