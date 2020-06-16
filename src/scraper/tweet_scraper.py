import GetOldTweets3 as got
import pandas as pd

def pull_tweets(username, start_date, end_date):
	"""
	Pull old tweets
	username (string) = Twitter username
	count (numeric) = Number of tweets to pull. Max 3000
	start_date (string) = YYYY-MM-DD
	end_date (string) = YYYY-MM-DD
	"""

    # Creation of query object
	tweetCriteria = got.manager.TweetCriteria().setUsername(username).setSince(start_date).setUntil(end_date)

    # Creation of list that contains all tweets
	tweets = got.manager.TweetManager.getTweets(tweetCriteria)

    # Create df for tweets
	user_tweets = pd.DataFrame([[tweet.date, tweet.text] for tweet in tweets])
    
	return user_tweets