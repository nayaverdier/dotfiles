function profzsh() {
    export PROFILE_ZSH_STARTUP=true
    zsh -i -c exit
    unset PROFILE_ZSH_STARTUP
}
