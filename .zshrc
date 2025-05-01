export PATH=/usr/local/bin:/Users/leo/bin:/Users/leo/.npm-global/bin:$PATH
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
bindkey '^[[A' atuin-up-search
bindkey '^[OA' atuin-up-search
# git clone https://github.com/zsh-users/zsh-autosuggestions
source $HOME/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=blue"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/leo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/leo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/leo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/leo/google-cloud-sdk/completion.zsh.inc'; fi

# Added by Windsurf
export PATH="/Users/leo/.codeium/windsurf/bin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
