#!/bin/sh

echo "Generating a new SSH key for GitHub..."

# Generates the key (need to pass in your email address)
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
ssh-keygen -t ed25519 -C $1 -f ~/.ssh/id_ed25519

# Starting up the agent and adding the key
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
echo "starting the agent"
eval "$(ssh-agent -s)"
echo "creating the config, adding ssh key to agent and storing passphrase in keychain"
touch ~/.ssh/config
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_ed25519" | tee ~/.ssh/config

ssh-add -K ~/.ssh/id_ed25519

# Adding your SSH key to your GitHub account
# https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
echo "run 'pbcopy < ~/.ssh/id_ed25519.pub' and paste that into GitHub > Settings > new ssh key"
echo "also authorise it for SSO"
# https://docs.github.com/articles/authenticating-to-a-github-organization-with-saml-single-sign-on/
echo "don't forget to remove old keys"