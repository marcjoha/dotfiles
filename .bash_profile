# ~/.bash_profile - Loaded on login shells

# 1. Load Brew Environment
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Source ~/.bashrc if it exists
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# 3. Path configurations
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/majohansson/bin:$PATH"
export PATH="/Users/majohansson/.antigravity/antigravity/bin:$PATH"

# 4. Git Prompt (requires bash-git-prompt installed via Homebrew)
if [ -f "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="/opt/homebrew/opt/bash-git-prompt/share"
  source "/opt/homebrew/opt/bash-git-prompt/share/gitprompt.sh"
fi

# 5. Google Cloud SDK configurations
if [ -f '/Users/majohansson/bin/google-cloud-sdk/path.bash.inc' ]; then 
  source '/Users/majohansson/bin/google-cloud-sdk/path.bash.inc'
fi
if [ -f '/Users/majohansson/bin/google-cloud-sdk/completion.bash.inc' ]; then 
  source '/Users/majohansson/bin/google-cloud-sdk/completion.bash.inc'
fi

# 6. Aliases & General Settings
alias g="gemini"

# Start in scratch folder
cd /Users/majohansson/Scratch
