library(tidyverse)
library(tidytext)
library(ggplot2)
library(lubridate)
library(RColorBrewer)

colors <-colorRampPalette(c("#30cbcf", "#7cd8c9", "#b4e3c5"))

df <- read_csv("../data/gpg.csv")

custom_stop_words <- c(stop_words$word , "global", "public", "good", "common")

#analyze words
words <- df %>%
  unnest_tokens(word, text) %>%
  filter (!word %in% custom_stop_words) %>%
  count(word, sort = TRUE) %>%
  head(10)

# plot
ggplot(words, aes(x=word, y = n, fill = word)) + geom_bar(stat="identity", show.legend = F) + 
  scale_fill_manual(values = colors(10)) + 
  theme(plot.title = element_text(hjust = 0.5)) +
  ggtitle("Most Common Words")

# join the words with AFINN library
afinn_words <- df %>%
  unnest_tokens(word, text) %>%
  filter (!word %in% custom_stop_words) %>%
  inner_join(get_sentiments("afinn"), by = "word")

########### Get the sum of scores for each day
word_scores <- afinn_words %>%
  group_by(week=floor_date(date, "week")) %>% # group by date
  summarise(score = mean(value)) # add all values for the score

# plot by date
ggplot(word_scores, aes(x = week, y = score, fill=ifelse(score > 0, T, F))) + geom_bar(stat="identity", show.legend = F) +
  ylim(-2.5,2.5) + theme(plot.title = element_text(hjust = 0.5)) +
  ggtitle("Average Sentiment Score of Tweets Per Week")

twitter_users <- c("WHO", "msf_access", "GaviSeth")

df %>%
  filter(user %in% twitter_users)

ymd(as.Date(df$date)) %>% format("%d-%m-%Y")
         
head(df$date)
