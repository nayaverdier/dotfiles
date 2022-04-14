# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit;
else
        compinit -C;
fi;

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# highlight selection in menu underneath command
zstyle ':completion:*' menu select

zstyle ':completion:*' completer _extensions _complete _approximate

zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'm:{a-zA-Z\-}={A-Za-z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-zA-Z\-}={A-Za-z\_}'
