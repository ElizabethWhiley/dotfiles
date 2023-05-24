# Path to dotfiles.
export DOTFILES=$HOME/dotfiles 

# prepend all these directories to the existing path - says where to look for binaries
# : separator between directories
export PATH="$DOTFILES/bin:$HOME/bin:/usr/local/bin:$PATH" 

# openssl
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" #append code

# go.
export GOPRIVATE="github.com/MYOB-Technology/*,github.com/myob-ops/*,github.com/elizabethwhiley/*" # tells it not to check imports at that address

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

# add custom commands to awscli
aws() {
    case $* in
        # shortcut to get info about authed AWS account
        auth) command aws sts get-caller-identity ;;
        # shortcut to get arn of authed AWS account
        who) command aws sts get-caller-identity --query "Arn" --output text ;;
        # shortcut to log into ecr for authed AWS account
        "ecr "*.dkr.ecr.*.amazonaws.com*) command aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin "$2";; 
        *) command aws "$@" # everything else 
    esac
}

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh