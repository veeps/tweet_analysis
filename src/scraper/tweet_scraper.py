import GetOldTweets3 as got
import pandas as pd
import regex as re
import string


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


def clean_tweets(df, tweets):
	"""
	Clean text column
	df = dataframe
	tweets (string) = column name containing tweets
	"""
	# lowercase text
	df[tweets] = df[tweets].str.lower()

	# remove URLs
	df[tweets] = df[tweets].map(lambda x: re.sub('http[s]?:\/\/[^\s]*', ' ', x))

	# remove URL cutoffs
	df[tweets] = df[tweets].map(lambda x: re.sub('\\[^\s]*', ' ', x))

	# remove spaces
	df[tweets] = df[tweets].map(lambda x: re.sub('\n', ' ', x))

	# remove picture URLs
	df[tweets] = df[tweets].map(lambda x: re.sub('pic.twitter.com\/[^\s]*', ' ', x))

	# remove blog/map type
	df[tweets] = df[tweets].map(lambda x: re.sub('blog\/maps\/info\/[^\s]*', ' ', x))

	# remove hashtags =
	df[tweets] = df[tweets].map(lambda x: re.sub("\#[\w]*", "", x))

	# remove AT users
	df[tweets] = df[tweets].map(lambda x: re.sub("\@[\w]*", "", x))

	# remove single quotations
	df[tweets] = df[tweets].map(lambda x: re.sub("'", "", x))
	df[tweets] = df[tweets].map(lambda x: re.sub("'", "", x))

	# remove characters that are not word characters or digits
	df[tweets] = df[tweets].map(lambda x: re.sub("[^\w\d]", " ", x))

	# remove all characters that are not letters
	df[tweets] = df[tweets].map(lambda x: re.sub("[^a-zA-Z]", " ", x))

	# remove multiple spaces
	df[tweets] = df[tweets].map(lambda x: re.sub("\s{2,6}", " ", x))

	# drop duplicate rows
	df.drop_duplicates(subset='text', keep='first', inplace=True)

	# remove multiple spaces
	df[tweets] = df[tweets].map(lambda x: re.sub("\s{3,20}", "", x))

	return df