export LANG=sv_SE.UTF-8 LC_ALL=sv_SE.UTF-8
cd /Users/majohansson/Documents

if [ `which brew` ]; then 
  unset PROMPT_COMMAND
  if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
    __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
    GIT_PROMPT_THEME=Solarized
    source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
  fi
fi

source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"

