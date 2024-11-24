import tweepy
import logging
import os
from dotenv import load_dotenv
from screenshot import run

# Loading the environment variables
load_dotenv()


# Initializing the logging 
logging.basicConfig(
    level=logging.DEBUG,  
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# Authenticate to Twitter using client 
client = tweepy.Client(
    bearer_token=os.getenv('BEARER'),
    consumer_key=os.getenv('API_KEY'),
    consumer_secret=os.getenv('API_SECRET'),
    access_token=os.getenv('ACCESS_TOKEN'),
    access_token_secret=os.getenv('ACCESS_SECRET')
)

auth = tweepy.OAuth1UserHandler(
    os.getenv('API_KEY') ,os.getenv('API_SECRET'), os.getenv('ACCESS_TOKEN'), os.getenv('ACCESS_SECRET')
)
api = tweepy.API(auth)

def fetch_mentions():
    """
    Fetch mentions of the authenticated user.
    """
    try:

        user_id = os.getenv('USER_ID')

        logging.info(f"Fetching mentions for user ID: {user_id}")
 
        # Fetch the mentions
        response = client.get_users_mentions(
            id=user_id,
            expansions="author_id",  # Include author details
            tweet_fields="created_at",  # Include additional tweet fields
            user_fields="username" , # Include user fields like username,
            since_id = read_since_id() if read_since_id() != "None" else None
        )

        # Checking if mentions exist
        if response.data:
            users = {user.id: user.username for user in response.includes["users"]}
            for tweet in response.data:
                author_id = tweet.author_id
                username = users.get(author_id, "Unknown")
                text = tweet.text
                created_at = tweet.created_at

                # Logging the details
                logging.info(f"Mentioned by @{username} (ID: {author_id}): {text} at {created_at}")

                # Responding to the mention
                reply_to_mention(tweet.id, username)
            
            newest_id = response.data[0].id  # The most recent tweet ID
            update_since_id(newest_id)  # Save the updated SINCE_ID
            logging.info(f"Updated SINCE_ID: {newest_id}")

        else:
            logging.info("No new mentions found.")

    except tweepy.TweepyException as e:
        logging.error(f"Failed to fetch mentions: {e}")
    except Exception as e:
        logging.error(f"An unexpected error occurred: {e}")


def reply_to_mention(tweet_id, username):
    """
    Reply to a specific mention with a text and an image.
    """
    try:
        # Ensure the image exists in the same directory
        image_path = run(username)
        if not os.path.exists(image_path):
            logging.error(f"Image {image_path} not found in the directory.")
            return
        
        # Upload the image
        media = api.media_upload(filename=image_path, file=open(image_path, "rb"))
        
        # Post a reply with the image
        reply_text = f"Hello @{username}, thanks for the mention!"
        client.create_tweet(
            text=reply_text,
            in_reply_to_tweet_id=tweet_id,
            media_ids=[media.media_id_string]
        )
        logging.info(f"Replied to @{username} with an image successfully.")

        if os.path.exists(image_path):
            os.remove(image_path)
            print(f"Deleted cropped image: {image_path}")
        
    except tweepy.TweepyException as e:
        logging.error(f"Failed to reply to @{username}: {e}")
    except Exception as ex:
        logging.error(f"An error occurred: {ex}")

def update_since_id(new_id):
    with open("since_id.txt", "w") as file:
        file.write(str(new_id))

def read_since_id():
    try:
        with open("since_id.txt", "r") as file:
            return file.read().strip()
    except FileNotFoundError:
        return None  # If the file does not exist, start fresh



if __name__ == "__main__":
    fetch_mentions()