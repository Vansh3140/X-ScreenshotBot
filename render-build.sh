#!/usr/bin/env bash
# exit on error
set -o errexit

# Define storage directory
STORAGE_DIR=/opt/render/project/.render

# Install specific version of Chrome (114)
echo "...Installing Chrome"
mkdir -p $STORAGE_DIR/chrome
cd $STORAGE_DIR/chrome

# Download specific version of Chrome (114.0.5735.90)
wget -q https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.90-1_amd64.deb
dpkg -x ./google-chrome-stable_114.0.5735.90-1_amd64.deb $STORAGE_DIR/chrome
rm ./google-chrome-stable_114.0.5735.90-1_amd64.deb

# Install matching ChromeDriver
echo "...Installing ChromeDriver"
mkdir -p $STORAGE_DIR/chromedriver
cd $STORAGE_DIR/chromedriver

# Use matching ChromeDriver version
CHROMEDRIVER_VERSION="114.0.5735.90"
echo "Installing ChromeDriver version: $CHROMEDRIVER_VERSION"

wget -q -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
unzip -o /tmp/chromedriver.zip
chmod +x chromedriver
rm /tmp/chromedriver.zip

# Export PATH for the current session
export PATH="$STORAGE_DIR/chrome/opt/google/chrome:$STORAGE_DIR/chromedriver:$PATH"

# Verify installations
echo "Verifying installations..."
$STORAGE_DIR/chrome/opt/google/chrome/chrome --version || echo "Chrome version check failed"
$STORAGE_DIR/chromedriver/chromedriver --version || echo "ChromeDriver version check failed"
