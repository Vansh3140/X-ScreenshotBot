#!/usr/bin/env bash
# exit on error
set -o errexit

# Enable debug mode
set -x

# Define storage directory
STORAGE_DIR=/opt/render/project/.render

# Install Chrome
echo "...Installing Chrome"
mkdir -p $STORAGE_DIR/chrome
cd $STORAGE_DIR/chrome

# Try multiple fallback URLs for Chrome 114
CHROME_URLS=(
    "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/114.0.5735.90/linux64/chrome-linux64.zip"
    "https://storage.googleapis.com/chrome-for-testing-public/114.0.5735.90/linux64/chrome-linux64.zip"
)

success=false
for url in "${CHROME_URLS[@]}"; do
    if wget -q "$url" -O chrome.zip; then
        echo "Successfully downloaded Chrome from $url"
        unzip -q chrome.zip
        success=true
        break
    fi
done

if [ "$success" = false ]; then
    echo "Failed to download Chrome from any source"
    exit 1
fi

# Install ChromeDriver
echo "...Installing ChromeDriver"
mkdir -p $STORAGE_DIR/chromedriver
cd $STORAGE_DIR/chromedriver

# Download ChromeDriver 114
CHROMEDRIVER_URL="https://storage.googleapis.com/chrome-for-testing-public/114.0.5735.90/linux64/chromedriver-linux64.zip"
if ! wget -q "$CHROMEDRIVER_URL" -O chromedriver.zip; then
    echo "Failed to download ChromeDriver"
    exit 1
fi

unzip -q chromedriver.zip
chmod +x chromedriver-linux64/chromedriver
mv chromedriver-linux64/chromedriver ./
rm -rf chromedriver-linux64 chromedriver.zip

# Export PATH for the current session
export PATH="$STORAGE_DIR/chrome/chrome-linux64:$STORAGE_DIR/chromedriver:$PATH"

# Create version file
echo "CHROME_VERSION=114.0.5735.90" > $STORAGE_DIR/versions.txt
echo "CHROMEDRIVER_VERSION=114.0.5735.90" >> $STORAGE_DIR/versions.txt

# Print debug information
echo "Contents of chrome directory:"
ls -la $STORAGE_DIR/chrome
echo "Contents of chromedriver directory:"
ls -la $STORAGE_DIR/chromedriver

echo "Build script completed successfully"
