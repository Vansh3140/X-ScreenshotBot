from selenium import webdriver
import undetected_chromedriver as uc
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import time
import json
from PIL import Image
import os
from dotenv import load_dotenv
import logging

load_dotenv()

# Initializing the logging 
logging.basicConfig(
    level=logging.DEBUG,  
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def run(username: str):
    # Initialize Chrome options
    options = uc.ChromeOptions()
    options.add_argument('--disable-gpu')  # Disable GPU for headless mode
    options.add_argument('--no-sandbox')  # Disable sandbox for Docker environments (Render)
    options.add_argument("--headless=new")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.add_argument("--disable-infobars")
    options.add_argument("--enable-javascript")
    options.add_argument("--window-size=1920,1080")
    options.add_argument("--start-maximized")
    options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36")

    options.binary_location = '/usr/bin/google-chrome'  # Path to Chrome installed in Render

    
    # Initialize the WebDriver with ChromeDriverManager to install ChromeDriver automatically
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    # Open the base URL
    driver.get("https://x.com")  # Open the website
    
    # Load cookies from environment variable (make sure it's set correctly)
    cookies = json.loads(os.getenv('COOKIES', '[]'))  # Default to empty list if not set
    for cookie in cookies:
        driver.add_cookie(cookie)
    
    # Navigate to the user's profile using the username
    driver.get(f"https://x.com/{username}")
    time.sleep(20)  # Allow the page to load
    
    # Take a screenshot
    screenshot_path = f"{username}-screenshot.png"
    driver.save_screenshot(screenshot_path)
    print(f"Screenshot taken successfully: {screenshot_path}")
    
    # Process the image (cropping)
    image = Image.open(screenshot_path)
    crop_box = (1200, 0, 2400, 1200)  # Adjust crop box based on your need
    cropped_image = image.crop(crop_box)
    output_path = f"{username}-profile.png"
    cropped_image.save(output_path)
    print(f"Cropped image saved to: {output_path}")

    # Delete the original screenshot after processing
    if os.path.exists(screenshot_path):
        os.remove(screenshot_path)
        print(f"Deleted original screenshot: {screenshot_path}")
    
    # Close the browser session
    driver.quit()
    
    return output_path
