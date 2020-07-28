library(shiny)
library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(DT)
library(tidytext)
library(textdata)

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
                 choices=c("WHO", "GaviSeth", "msf_access", "WorldBank", "CEPI_Vaccine"),
                 selected="WHO")
           ),
    column(9,DTOutput("tweets_df"))
))
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