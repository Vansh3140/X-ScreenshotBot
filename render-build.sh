#!/usr/bin/env bash
# exit on error
set -o errexit

# Define storage directory for the render build
STORAGE_DIR=/opt/render/project/.render

# Install Chrome if not present
if [[ ! -d $STORAGE_DIR/chrome ]]; then
  echo "...Downloading Chrome"
  mkdir -p $STORAGE_DIR/chrome
  cd $STORAGE_DIR/chrome
  wget -P ./ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  
  # Extract the .deb package
  dpkg -x ./google-chrome-stable_current_amd64.deb $STORAGE_DIR/chrome
  rm ./google-chrome-stable_current_amd64.deb  # Clean up the downloaded file
  
  echo "...Chrome installed in $STORAGE_DIR/chrome"
else
  echo "...Using Chrome from cache"
fi

# Get Chrome version
CHROME_VERSION=$(google-chrome --version | cut -d ' ' -f 3 | cut -d '.' -f 1)
echo "Chrome version: $CHROME_VERSION"

# Install matching ChromeDriver
echo "...Installing matching ChromeDriver"
mkdir -p $STORAGE_DIR/chromedriver
cd $STORAGE_DIR/chromedriver

CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
wget -q -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
unzip -o /tmp/chromedriver.zip
chmod +x chromedriver
rm /tmp/chromedriver.zip

# Add both Chrome and ChromeDriver to PATH
export PATH="${PATH}:$STORAGE_DIR/chrome/opt/google/chrome:$STORAGE_DIR/chromedriver"

# Verify installations
echo "Chrome version:"
google-chrome --version
echo "ChromeDriver version:"
chromedriver --version
