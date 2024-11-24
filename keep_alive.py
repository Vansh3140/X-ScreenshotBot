from flask import Flask
import threading
import time
import os
import logging
from dotenv import load_dotenv
from main import fetch_mentions

# Load environment variables
load_dotenv()

# Flask app to bind the port
app = Flask(__name__)

# Logging setup
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')

def background_task():
    """
    This function runs your task continuously in the background.
    """
    while True:
        # Here, we're calling the task from your main script that runs the task
        logging.info("Running background task...")
        fetch_mentions()
        
        # Sleep for some time before running again (to avoid rate-limiting issues)
        time.sleep(900)  # 15 minutes interval (adjust as necessary)

@app.route('/')
def home():
    """
    A simple route to keep the web service alive.
    """
    return "Worker is running. Task is being processed in the background."

if __name__ == '__main__':
    # Start the background task in a separate thread
    threading.Thread(target=background_task, daemon=True).start()

    # Run the Flask app to bind the web service to a port
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 5000)))  # Render will assign a port automatically
