#!/bin/sh
#
# Bootstrap for this dotfiles repo.
#
# Strict POSIX sh -- no [[ ]], no =~, no arrays. This file has to run under
# FreeBSD's /bin/sh (ash), which is not bash. Verify with:
#     sh -n setup.sh && checkbashisms setup.sh
#
# All it does is find a Python 3 and hand over to tools/install.py, which does
# the real work. Run `./setup.sh --help` for the available flags.
#
# You do not need this script to use the repo: `stow <package>` on its own is
# the normal workflow, especially on CLI-only machines.

set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
INSTALLER="$REPO/tools/install.py"

die() {
	printf 'xx %s\n' "$*" >&2
	exit 1
}

# Identify the package manager by probing for its binary. uname alone is not
# enough: every Linux distro reports "Linux".
detect_manager() {
	case "$(uname -s)" in
	FreeBSD)
		command -v pkg >/dev/null 2>&1 && echo pkg && return
		;;
	Darwin)
		command -v brew >/dev/null 2>&1 && echo brew && return
		;;
	Linux)
		for mgr in pacman apt-get dnf emerge; do
			if command -v "$mgr" >/dev/null 2>&1; then
				echo "$mgr"
				return
			fi
		done
		;;
	esac
	echo ""
}

# Install Python 3 and nothing else; install.py handles every other package.
install_python() {
	mgr=$1
	printf ':: Python 3 not found, installing it with %s...\n' "$mgr"
	case "$mgr" in
	pacman) sudo pacman -S --needed --noconfirm python ;;
	pkg) sudo pkg install -y python3 ;;
	brew) brew install python3 ;;
	apt-get) sudo apt-get update && sudo apt-get install -y python3 ;;
	dnf) sudo dnf install -y python3 ;;
	emerge) sudo emerge --noreplace dev-lang/python ;;
	*) die "no supported package manager found; install Python 3 manually and re-run" ;;
	esac
}

[ -f "$INSTALLER" ] || die "missing $INSTALLER (is the repo complete?)"

if ! command -v python3 >/dev/null 2>&1; then
	install_python "$(detect_manager)"
fi

command -v python3 >/dev/null 2>&1 ||
	die "Python 3 still not on PATH after install; cannot continue"

exec python3 "$INSTALLER" "$@"
