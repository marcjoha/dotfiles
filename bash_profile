export LANG=sv_SE.UTF-8 LC_ALL=sv_SE.UTF-8

unset PROMPT_COMMAND
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_THEME=Solarized
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

export PATH="$PATH:$(brew --prefix openssl)/bin:$HOME/docs/dev/flutter/bin"
export PATH="/usr/local/opt/openssl/bin:$PATH"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"

alias k='kubectl'
complete -F __start_kubectl k
