from nltk.corpus import stopwords
from sklearn.feature_extraction import text 
import pandas as pd

def top_words(vectorizer, tweets):
    df = pd.DataFrame(vectorizer.fit_transform(tweets).toarray(), columns=vectorizer.get_feature_names())
    
    # create dataframe with top words
    top_words = df.sum().T.sort_values(0, ascending=False).head(30)
    
    return top_words