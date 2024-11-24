#!/usr/bin/env bash
# exit on error
set -o errexit

# Define storage directory
STORAGE_DIR=/opt/render/project/.render

# Install Chrome
echo "...Installing Chrome"
mkdir -p $STORAGE_DIR/chrome
cd $STORAGE_DIR/chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -x ./google-chrome-stable_current_amd64.deb $STORAGE_DIR/chrome
rm ./google-chrome-stable_current_amd64.deb

# Install ChromeDriver
echo "...Installing ChromeDriver"
mkdir -p $STORAGE_DIR/chromedriver
cd $STORAGE_DIR/chromedriver

# Get Chrome version without relying on PATH
CHROME_VERSION=$($STORAGE_DIR/chrome/opt/google/chrome/chrome --version | cut -d ' ' -f 3 | cut -d '.' -f 1) || "131"
CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")

echo "Chrome version: $CHROME_VERSION"
echo "ChromeDriver version: $CHROMEDRIVER_VERSION"

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
