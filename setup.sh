#!/usr/bin/sh

get_pkgs() {
  cd ~/dotfiles
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
  cd ~/dotfiles || exit 1
  while read -r package; do
    # Skip any empty lines in the file
    if [[ -z "$package" ]]; then
      continue
    fi

    # Check if the package directory actually exists before trying to stow it
    if [ -d "$package" ]; then
      echo "Stowing '$package'..."
      stow "$package"
    else
      echo "WARNING: Directory for package '$package' not found. Skipping."
    fi
  done <all_stowed_files.txt

  echo "All configurations have been stowed."
}

install_Vencord() {
  sudo VencordInstaller
}

main() {
  exec_at=$(pwd)
  if ! which yay >/dev/null; then
    echo "yay is not installed, installing..."
    sudo pacman -S --needed git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd yay
    makepkg -si
  fi
  cd ${exec_at}
  get_pkgs
  if ! which zsh >/dev/null; then
    echo "Something went worng with the zsh installation"
    echo "Since we uses oh-my-zsh, the installation will be aborted..."
    sleep 1
    exit 1
  fi
  chsh -s /usr/bin/zsh
  clone_powerlevel10k
  cd ${exec_at}
  mv ~/.config/hypr/ ~/.config/hypr_bak
  mv ~/.config/kitty/ ~/.config/kitty_bak/
  stow_dir
  sudo VencordInstaller
  echo "The installation completed, please reboot your computer."
}
main
