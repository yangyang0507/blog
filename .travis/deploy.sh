#!/bin/bash
# Decrypt the private key
openssl aes-256-cbc -K $encrypted_a6b7c41c3c70_key -iv $encrypted_a6b7c41c3c70_iv -in .travis/travis.enc -out ~/.ssh/id_rsa -d
# Set the permission of the key
chmod 600 ~/.ssh/id_rsa
# Start SSH agent
eval $(ssh-agent)
# Add the private key to the system
ssh-add ~/.ssh/id_rsa
# Copy SSH config
cp .travis/ssh_config ~/.ssh/config
# Set Git config
git config --global user.name "D.Yang"
git config --global user.email koyangslash@gmail.com
# Clone the repository
git clone -b master git@github.com:yangyang0507/yangyang0507.github.io.git .deploy_git
# Deploy to GitHub
npm run deploy
