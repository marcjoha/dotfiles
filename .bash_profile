export PATH="/Users/majohansson/Scratch/bin:${PATH}"
export PATH="/Users/majohansson/Scratch/bin/flutter/bin:${PATH}"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"

# Fix git prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Don't forget about aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/majohansson/Scratch/bin/google-cloud-sdk/path.bash.inc' ]; then . '/Users/majohansson/Scratch/bin/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/majohansson/Scratch/bin/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/majohansson/Scratch/bin/google-cloud-sdk/completion.bash.inc'; fi
