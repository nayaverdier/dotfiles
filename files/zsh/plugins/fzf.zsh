export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git/ --ignore node_modules/ -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules' --exclude '.venvs' --exclude '.venv' --exclude '.rustup' --exclude '/home/naya/go' --exclude '.cargo' --type d"

# Note: this fd command prefixes results with ./ which is undesirable from FZF in vim
# export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules' --exclude '.venvs' --exclude '.venv' --exclude '.rustup' --exclude '/home/naya/go' --exclude '.cargo'"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

. /usr/share/fzf/completion.zsh
. /usr/share/fzf/key-bindings.zsh
