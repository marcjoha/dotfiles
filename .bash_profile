export PATH="${PATH}:/Users/majohansson/Scratch/bin"
export PATH="${PATH}:/Users/majohansson/Scratch/bin/flutter/bin"
export PATH="${PATH}:/opt/homebrew/bin"

# Fix git prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# Don't forget about aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

