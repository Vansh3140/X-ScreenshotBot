#!/usr/bin/env bash
# exit on error
set -o errexit

# Define storage directory for the render build
STORAGE_DIR=/opt/render/project/.render

# Check if Chrome is already downloaded and extracted
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

# Ensure Chrome is available in the PATH for the web service
export PATH="${PATH}:$STORAGE_DIR/chrome/opt/google/chrome"

# Optionally, verify Chrome is available
google-chrome --version
