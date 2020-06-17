from nltk.corpus import stopwords
from sklearn.feature_extraction import text 
import pandas as pd

def top_words(vectorizer, tweets):
	"""
	Selects the top 30 words 
	vectorizer = type of vectorizer
	tweets = list of tweets to parse
	"""
	df = pd.DataFrame(vectorizer.fit_transform(tweets).toarray(), columns=vectorizer.get_feature_names())
    
    # create dataframe with top words
	top_words = df.sum().T.sort_values(0, ascending=False).head(30)
    
	return top_words


def select_tweets(df, column, keywords):
	"""
	Filters dataframe based on a list of keywords

	df = dataframe
	column = tweets column
	keywords = list of keywords
	"""
	df = df[df[column].str.contains('|'.join(keywords), regex=True)]

	return df 