library(shiny)
library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(DT)
library(tidytext)



# read afinn words
afinn <- readr::read_csv("./data/afinn.csv")

# update date options
#df$date <- ymd(as.Date(df$date)) %>% format("%d-%m-%Y")

#rename date column
df<- df %>% 
  rename(
  tweet_date= date
)

#update data format
df$tweet_date <- lubridate::ymd(as.Date(df$tweet_date))


# custom stop words
custom_stop_words <- c(stop_words$word , "global", "public", "good", "common", "19")

#analyze words
words <- df %>%
  unnest_tokens(word, text) %>%
  filter (!word %in% custom_stop_words) %>%
  count(word, sort = TRUE) %>%
  head(10)

# create custom gradient palette 
colors <-colorRampPalette(c("#30cbcf", "#7cd8c9", "#b4e3c5"))

# plot
output$plot_words <- renderPlot({
  ggplot(words, aes(x=word, y = n, fill = word)) + geom_bar(stat="identity", show.legend = F) + 
    scale_fill_manual(values = colors(10)) + 
    theme(plot.title = element_text(hjust = 0.5)) +
    ylab("Number of Times Words Appeared") +
    ggtitle("Most Common Words")
})

# join the words with AFINN library
afinn_words <- df %>%
  unnest_tokens(word, text) %>%
  filter (!word %in% custom_stop_words) %>%
  inner_join(afinn, by = "word")


# try to combine this back to original df
df_scores <- afinn_words %>%
  group_by(tweet_date, user) %>%
  summarise(sentiment = sum(value))


test <- df_scores %>%
  right_join(df, by = c("user", "tweet_date"))

########### Get the sum of scores for each day
word_scores <- afinn_words %>%
  group_by(week=floor_date(tweet_date, "week")) %>% # group by date
  summarise(score = mean(value)) # add all values for the score

# plot by date
output$plot_sentiment<- renderPlot({
  ggplot(word_scores, aes(x = week, y = score, fill=ifelse(score > 0, T, F))) + geom_bar(stat="identity", show.legend = F) +
    ylim(-2.5,2.5) + theme(plot.title = element_text(hjust = 0.5)) +
    ggtitle("Average Sentiment Score of Tweets Per Week")
})

# get tweets table by user


output$tweets_df <- renderDT(
      if(input$checkGroup == "No Filter"){
        test %>% select(tweet_date, user, text)
        } else test %>% filter(user %in% input$checkGroup) %>% select(tweet_date, user, text, sentiment)
      , options=list(info = F, paging = T, searching = T) 
)
  

  
 
