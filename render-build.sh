#!/usr/bin/env bash

# Install dependencies
apt-get update && apt-get install -y wget gnupg unzip

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Verify Chrome installation
google-chrome --version

echo "Build script completed successfully."