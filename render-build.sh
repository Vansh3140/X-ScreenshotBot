#!/usr/bin/env bash

# Update and install basic dependencies
apt-get update && apt-get install -y wget gnupg unzip

# Install dependencies required for Chrome
apt-get install -y \
    libx11-xcb1 \
    libfontconfig1 \
    libxrandr2 \
    libxss1 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libglu1-mesa

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Verify Chrome installation
google-chrome --version

# Clean up to keep the environment clean
apt-get clean

export GOOGLE_CHROME_BIN=/usr/bin/google-chrome

echo "Build script completed successfully."
