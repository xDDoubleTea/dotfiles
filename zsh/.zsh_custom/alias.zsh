# Debian and Ubuntu install bat's binary as `batcat`, because the name `bat`
# belongs to bacula-console-qt there. Resolve it once: the fzf preview below
# runs through `sh -c`, where the alias would not apply.
if (( $+commands[bat] )); then
	_bat=bat
elif (( $+commands[batcat] )); then
	_bat=batcat
	alias bat='batcat'
else
	_bat=cat
fi

alias fzf="fzf --preview '$_bat --color=always --style=numbers --line-range :500 {}' --preview-window=up:30% --bind 'ctrl-a:select-all+accept' --bind 'ctrl-d:toggle-preview' --bind 'ctrl-f:page-down' --bind 'ctrl-b:page-up'"
unset _bat
alias fzfe='vim $(wheretf)'
alias lg='lazygit'
alias tmuxa='tmux attach || tmux new-session -s default'
alias cd='z'
alias ls='eza --icons --color=always --group-directories-first'
alias v="nvim"
alias ll='eza -alhF --icons --color=always --group-directories-first'
alias la='eza -ah --icons --color=always --group-directories-first'
alias l='eza -lhF --icons --color=always --group-directories-first'
alias lf='yazi'
# scrcpy closes its window shortly after the phone disconnects (exit code 2) and
# has no option to keep it, so relaunch once the phone is back instead.
phonemirror() {
  local rc
  while true; do
    adb wait-for-device || return
    scrcpy --no-clipboard-autosync --keyboard=aoa --disable-screensaver --stay-awake \
      --video-codec=h265 --max-fps=120 --video-bit-rate=40M --audio-source=playback \
      --window-title=PhoneMirror "$@"
    rc=$?
    (( rc == 2 )) || return $rc
    print "phonemirror: phone disconnected, waiting for it (Ctrl+C to stop)"
  done
}
alias parui='parui -p=yay'
alias lt='lsd --tree --depth 3'
alias lta='lt -a'
alias warptest='curl https://cloudflare.com/cdn-cgi/trace | grep warp'
