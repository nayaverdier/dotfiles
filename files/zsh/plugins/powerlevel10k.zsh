# make the right prompt flush to the right of the window
ZLE_RPROMPT_INDENT=0

# don't enable powerlevel10k from main tty
if [[ $TERM != "linux" ]]; then
  source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
fi
