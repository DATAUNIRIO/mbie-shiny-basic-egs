library(shiny)
library(ggvis)

load("forecasts.rda")

# Define UI for application that draws a histogram
shinyUI(fixedPage(
   # insert some CSS.  Down the track this would be stored in a separate file.
   tags$head(
      tags$style(HTML("
                      body {
         font-family: 'Lucida Sans Unicode', 'Lucida Grande', Verdana, Lucida, Helvetica, Arial, Calibri, sans-serif;
         color: rgb(0,0,0);
                      font-size: 12.1px;
                      line-height: 18.15px;
                      margin-bottom: 9.075px; 
                      list-style-image: url(http://www.mbie.govt.nz/bullet_double_green_8x8.png);
                      }
                      
                      h2 {
                      font-size:20px;
                      line-height: 24px;
                      color: rgb(0, 139, 198);
                      }
                      
                      
                      h3 {
                      font-size:15px;
                      line-height: 18px;
                      color: rgb(0, 139, 198);
                      }
                      
                      .selectize-dropdown, .selectize-input, label { 
                      font-weight: normal;   
                      }"
      ))),
   
   # Application title
   titlePanel("New Zealand tourism forecasts"),
   
   fixedRow(
      column(width=4, 
         selectInput("country",
                     "Choose a country:",
                     choices = as.character(unique(forecasts$Country)))
   ),
   column(width=2, p("Click on a point for the exact value"))),   
   fixedRow(
      column(width = 6, ggvisOutput("TotalVisitorArrivals")),
      column(width = 6, ggvisOutput("SpendPerDay"))
      ),
   fixedRow(
      column(width = 6,  ggvisOutput("AvLengthOfStay")),
      column(width = 6,  ggvisOutput("TotalVisitorSpend"))
   )
      

   
))
