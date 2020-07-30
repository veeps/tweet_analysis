library(shiny)
library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(DT)
library(tidytext)
library(textdata)

ui <- fluidPage(
  fluidRow(style="background-color: #7cd8c9",
    column(5,h2(style="padding-left: 40px", "Select Data Set")),
    column(2,div(style="padding: 20px", actionButton("gpg", "Global Public Good"))),
    column(2,div(style="padding: 20px", actionButton("gpgs", "Global Public Goods"))),
    column(2,div(style="padding: 20px", actionButton("gcg", "Global Common Good")))
  ),
  
  fluidRow(style="background-color: #7cd8c9; padding-left: 40px; padding-right: 40px", 
           p("This dashboard explores all the tweets that contain the keywords \"global public good\", \"global public goods\", 
           and \"global common good\" from June 1, 2019 to June 2, 2019. You can filter the data by clicking the buttons at the top.
             Sentiment score is calculated by assigning each word in the tweet a positive or negative value, and aggregating that score for the entire tweet mesage.")),
  
  fluidRow(style="padding-top:40px",
    column(6,plotOutput("plot_words")),
    column(6,plotOutput("plot_sentiment"))
  ),
  
  fluidRow(
    div(style="padding:20px",
    column(3,radioButtons("checkGroup",
                 label= h3("Explore Tweets From"),
                 choices=c("No Filter", "WHO", "GaviSeth", "msf_access", "WorldBank","UNITAID", "GHS", "DNDi", "DrTedros", "DrChristou", "CEPIvaccines" ), selected = "No Filter")
           ),
    column(9,DTOutput("tweets_df"))
  )),
  
  hr(),
  print("Twitter analysis project for MSF Access Campaign. This is a work in progress by Vivian Peng")

)

server <- function(input, output, session) {
  observeEvent(input$gpg,{
    df <- readr::read_csv("./data/gpg.csv")
    source("./text_plots.R", local = TRUE)
  })
  
  observeEvent(input$gpgs,{
    df <- readr::read_csv("./data/gpgs.csv")
    source("./text_plots.R", local = TRUE)
  })
  
  observeEvent(input$gcg,{
    df <- readr::read_csv("./data/gcg.csv")
   source("./text_plots.R", local = TRUE)
  })
  
  df <- readr::read_csv("./data/gpg.csv")
  source("./text_plots.R", local = TRUE)

  
}

shinyApp(ui, server)