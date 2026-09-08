# Homebrew's prefix depends on the architecture: /opt/homebrew on Apple
# silicon, /usr/local on Intel. brew shellenv sets PATH, MANPATH and INFOPATH
# for whichever is installed. This runs before the agent block below, which
# looks for keychain on PATH.
for _brew_prefix in /opt/homebrew /usr/local; do
	if [ -x "$_brew_prefix/bin/brew" ]; then
		eval "$("$_brew_prefix/bin/brew" shellenv)"
		break
	fi
done
unset _brew_prefix

case "$(uname)" in
	Linux)
		export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
		;;
esac

if [ -z "$SSH_AUTH_SOCK" ] && command -v keychain >/dev/null 2>&1; then
	eval $(keychain --eval --quiet id_ed25519)
fi
