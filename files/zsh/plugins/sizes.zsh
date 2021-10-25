function sizes() {
  setopt local_options null_glob
  du -hs ${1:+$1/}{.,}* | sort -hr
}

alias i='sizes'
