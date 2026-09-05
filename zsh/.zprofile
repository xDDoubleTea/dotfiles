case "$(uname)" in
	Linux)
		export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
		;;
esac

if [ -z "$SSH_AUTH_SOCK" ] && command -v keychain >/dev/null 2>&1; then
	eval $(keychain --eval --quiet id_ed25519)
fi
