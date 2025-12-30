# Path to dotfiles.
export DOTFILES=$HOME/dotfiles

# prepend all these directories to the existing path - says where to look for binaries
# : separator between directories
export PATH="$DOTFILES/bin:$HOME/bin:/usr/local/bin:$PATH"

# openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# aws.
export AWS_DEFAULT_REGION="ap-southeast-2"

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="cloud"

# Sets a custom folder
ZSH_CUSTOM=$DOTFILES

# Which plugins would you like to load?
plugins=(git)

source $ZSH/oh-my-zsh.sh

function die () { echo "$*" >&2; exit 1; }

aws_login() {
  "$DOTFILES/bin/aws-login" "$@"
}

function aws () {
  case $1 in
    profiles)
      command aws --no-cli-pager configure list-profiles
      ;;
    who)
      command aws --no-cli-pager sts get-caller-identity \
        --query "Arn" --output text
      ;;
    login)
      shift
      aws_login "$@"
      ;;
    *)
      command aws "$@"
      ;;
  esac
}

ecr() {
        echo "aws ecr get-login-password | docker login --username AWS --password-stdin REGISTRY-URL"
}

export NVM_DIR="$HOME/.nvm"
# Load nvm if available (guarded so zsh won't error if nvm isn't installed)
if command -v brew >/dev/null 2>&1 && [ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ]; then
  . "$(brew --prefix nvm)/nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi