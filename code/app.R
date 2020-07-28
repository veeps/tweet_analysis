library(shiny)
library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(DT)

ui <- fluidPage(
  fluidRow(
    column(3,h2("Select Data Set")),
    column(3,div(style="padding: 20px", actionButton("gpg", "Global Public Good"))),
    column(3,div(style="padding: 20px", actionButton("gpgs", "Global Public Goods"))),
    column(3,div(style="padding: 20px", actionButton("gcg", "Global Common Good")))
  ),
  
  fluidRow(
    column(6,plotOutput("plot_words")),
    column(6,plotOutput("plot_sentiment"))
  ),
  
  fluidRow(
    div(style="padding:20px",
    column(3,checkboxGroupInput("checkGroup",
                 label= h3("Explore Tweets From"),
                 choices=c("WHO", "GaviSeth", "msf_access"),
                 selected="WHO")
           ),
    column(9,DTOutput("tweets_df"))
))
)

server <- function(input, output, session) {
  observeEvent(input$gpg,{
    df <- read_csv("../data/gpg.csv")
  })
  
  observeEvent(input$gpgs,{
    df <- read_csv("../data/gpgs.csv")
  })
  
  observeEvent(input$gcg,{
    df <- read_csv("../data/gcg.csv")
  })
  
  # custom stop words
  custom_stop_words <- c(stop_words$word , "global", "public", "good", "common")
  
  #analyze words
  words <- df %>%
    unnest_tokens(word, text) %>%
    filter (!word %in% custom_stop_words) %>%
    count(word, sort = TRUE) %>%
    head(10)
  
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
    inner_join(get_sentiments("afinn"), by = "word")
  
  ########### Get the sum of scores for each day
  word_scores <- afinn_words %>%
    group_by(week=floor_date(date, "week")) %>% # group by date
    summarise(score = mean(value)) # add all values for the score
  
  # plot by date
  output$plot_sentiment<- renderPlot({
    ggplot(word_scores, aes(x = week, y = score, fill=ifelse(score > 0, T, F))) + geom_bar(stat="identity", show.legend = F) +
    ylim(-2.5,2.5) + theme(plot.title = element_text(hjust = 0.5)) +
    ggtitle("Average Sentiment Score of Tweets Per Week")
  })
  
  # get tweets table by user
  output$tweets_df <- renderDT( df %>%
    filter(user %in% input$checkGroup), options=list(info = F, paging = F, searching = T))

  
  
}

shinyApp(ui, server)