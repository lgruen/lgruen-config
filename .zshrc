# git clone https://github.com/mafredri/zsh-async
source $HOME/zsh-async/async.zsh

# git clone https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=blue"
ZSH_AUTOSUGGEST_STRATEGY=(history)
source $HOME/zsh-autosuggestions/zsh-autosuggestions.zsh

# git clone https://github.com/marlonrichert/zsh-autocomplete.git
#source $HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh

git_branch() {
    git branch 2>/dev/null | grep '^*' | sed 's/* //'
}

setopt PROMPT_SUBST

PROMPT='%B%F{blue}%n%F{magenta}@%m%f%b:%B%F{cyan}%~%f%b %B%F{green}$(git_branch)%f%b'$'\n''%F{25}>%f '

# Empty WORDCHARS = only alphanumeric characters are word chars
WORDCHARS=''

# Remove pipe from the list but keep the others
ZLE_REMOVE_SUFFIX_CHARS=$' \n\t;&'

eval "$(atuin init zsh)"
bindkey '^[[A' atuin-up-search
bindkey '^[OA' atuin-up-search

export PATH=~/bin:~/.npm-global/bin:$PATH

alias claude-code='claude update && claude'

# Rust
source ~/.cargo/env

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/leo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/leo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/leo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/leo/google-cloud-sdk/completion.zsh.inc'; fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
