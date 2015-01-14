library(shiny)
library(ggvis)

load("forecasts.rda")

# Define UI for application that draws a histogram
shinyUI(fixedPage(
   
   # Application title
   titlePanel("Forecasts example app with ggvis!"),
   
   # Sidebar with a slider input for the number of bins
   
         selectInput("country",
                     "Choose a country:",
                     choices = as.character(unique(forecasts$Country)))
      ,
      
   fixedRow(
      column(width = 4,  ggvisOutput("TotalVisitorArrivals")),
      column(width=4),
      column(width = 4,  ggvisOutput("SpendPerDay")),
      column(width = 4,  ggvisOutput("AvLengthOfStay")),
      column(width=4),
      column(width = 4,  ggvisOutput("TotalVisitorSpend"))
      


      
   )
   
))
