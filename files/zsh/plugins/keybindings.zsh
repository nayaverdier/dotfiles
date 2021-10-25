# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use vim key bindings
bindkey -v

# the vim delete char doesn't allow going beyond what
# existed before the current insert mode, this is
# basically equivalent to setting backspace=2 in vim
bindkey -v '^?' backward-delete-char

# beginning and end of the line with Ctrl-A/E
bindkey -v '^A' beginning-of-line
bindkey -v '^E' end-of-line

# fzf bindings
bindkey -v '^T' fzf-file-widget
bindkey -v '^R' fzf-history-widget
bindkey -v '^I' fzf-completion

# kill to the end of the line with Ctrl-K
bindkey -v '^K' kill-line

# fuzzy history search
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey -v "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey -v "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -v "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -v '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -v "${terminfo[kdch1]}" delete-char
else
  bindkey -v "^[[3~" delete-char
  bindkey -v "^[3;5~" delete-char
fi

# [Ctrl-Backspace] - delete whole backward-work
bindkey -v '^H' backward-kill-word
# [Ctrl-Delete] - delete whole forward-word
bindkey -v '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -v '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -v '^[[1;5D' backward-word

# don't expand history if space at the beginning
bindkey ' ' magic-space
