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

function die () { echo "$*" >&2; exit 1; }

function aws_login () {
        profile="${1:-}"
        [[ -n $profile ]] || die "usage: $0 profile"
        command aws sso login --profile $profile
        export AWS_PROFILE=$profile
        aws sts get-caller-identity --no-cli-pager
        ~/.aws/save-creds.sh $profile
}

function aws () {
        case $1 in
                profiles) command aws --no-cli-pager configure list-profiles ;;
                who) command aws --no-cli-pager sts get-caller-identity --query "Arn" --output text ;;
                use) export AWS_PROFILE=$2 ;;
                login) aws_login $2 ;;
                *) command aws "$@" ;;
        esac
}

ecr() {
        echo "aws ecr get-login-password | docker login --username AWS --password-stdin REGISTRY-URL"
}

cert-expiry () {
        if [[ "$1" == "-v" ]]
        then
                certigo connect $2
        else
                certigo connect -j $1 | jq '.certificates[0].not_after'
        fi
}

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh