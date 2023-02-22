#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if I don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if I don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc

# Removes .gitconfig from $HOME (if it exists) and symlinks the .gitconfig file from the dotfiles
rm ~/Library/Application\ Support/Code/User/settings.json
ln -s $HOME/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

rm ~/Library/Application\ Support/Code/User/keybindings.json
ln -s $HOME/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybinding.json

rm -rf ~/Library/Application\ Support/Code/User/snippets 
ln -s $HOME/dotfiles/vscode/snippets ~/Library/Application\ Support/Code/User/


# Removes vscode settings from and symlinks them from the dotfiles
rm -rf 
ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Get talon scripts
cd ~/.talon/user
git clone https://github.com/knausj85/knausj_talon knausj_talon
git clone https://github.com/phillco/talon_axkit.git

git clone https://github.com/tararoys/mouse_guide.git
git clone https://github.com/tararoys/dense-mouse-grid.git
git clone https://github.com/wolfmanstout/talon-gaze-ocr
git clone https://github.com/chaosparrot/talon_hud.git
git clone https://github.com/cursorless-dev/cursorless-talon.git cursorless-talon
echo "open talon and install conformer"
echo "install go and talon extensions in vscode"