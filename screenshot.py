from selenium import webdriver
import undetected_chromedriver as uc
from selenium.webdriver.chrome.service import Service
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
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument("--headless=new")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.add_argument("--disable-infobars")
    options.add_argument("--enable-javascript")
    options.add_argument("--window-size=1920,1080")
    options.add_argument("--start-maximized")
    options.add_argument("--disable-dev-shm-usage")  # Added this for Render
    options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36")
    
    # Path to Chrome installed in Render
    options.binary_location = "/opt/render/project/.render/chrome/chrome-linux64/chrome"
    
    try:
        # Initialize Chrome driver with undetected-chromedriver
        driver = uc.Chrome(
            options=options,
            service=Service(),
            version_main=114  # Specify Chrome version
        )
        
        # Open the base URL
        driver.get("https://x.com")
        
        # Load cookies from environment variable
        cookies = json.loads(os.getenv('COOKIES', '[]'))
        for cookie in cookies:
            driver.add_cookie(cookie)
        
        # Navigate to the user's profile
        driver.get(f"https://x.com/{username}")
        time.sleep(20)
        
        # Take a screenshot
        screenshot_path = f"{username}-screenshot.png"
        driver.save_screenshot(screenshot_path)
        print(f"Screenshot taken successfully: {screenshot_path}")
        
        # Process the image
        # image = Image.open(screenshot_path)
        # crop_box = (1200, 0, 2400, 1200)
        # cropped_image = image.crop(crop_box)
        # output_path = f"{username}-profile.png"
        # cropped_image.save(output_path)
        # print(f"Cropped image saved to: {output_path}")
        
        # Delete the original screenshot
        # if os.path.exists(screenshot_path):
        #     os.remove(screenshot_path)
        #     print(f"Deleted original screenshot: {screenshot_path}")
            
        return screenshot_path
        
    except Exception as e:
        logging.error(f"An error occurred: {str(e)}")
        raise
    finally:
        if 'driver' in locals():
            driver.quit()
