#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    unzip \
    libglib2.0-0 \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xvfb

# Define storage directory
STORAGE_DIR=/opt/render/project/.render

# Install Chrome
echo "...Installing Chrome"
mkdir -p $STORAGE_DIR/chrome
cd $STORAGE_DIR/chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -x ./google-chrome-stable_current_amd64.deb $STORAGE_DIR/chrome
rm ./google-chrome-stable_current_amd64.deb

# Create symlink for Chrome
ln -sf $STORAGE_DIR/chrome/opt/google/chrome/chrome /usr/local/bin/google-chrome

# Install ChromeDriver
echo "...Installing ChromeDriver"
mkdir -p $STORAGE_DIR/chromedriver
cd $STORAGE_DIR/chromedriver

# Get matching versions
CHROME_VERSION=$(google-chrome --version | cut -d ' ' -f 3 | cut -d '.' -f 1)
CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")

echo "Chrome version: $CHROME_VERSION"
echo "ChromeDriver version: $CHROMEDRIVER_VERSION"

wget -q -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
unzip -o /tmp/chromedriver.zip
chmod +x chromedriver
rm /tmp/chromedriver.zip

# Create symlink for ChromeDriver
ln -sf $STORAGE_DIR/chromedriver/chromedriver /usr/local/bin/chromedriver

# Verify installations
echo "Verifying installations..."
google-chrome --version
chromedriver --version
