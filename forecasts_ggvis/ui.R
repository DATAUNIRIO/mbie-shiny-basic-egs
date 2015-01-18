library(shiny)
library(ggvis)

load("forecasts.rda")

# Define UI for application that draws a histogram
shinyUI(fixedPage(
   # insert some CSS.  Down the track this would be stored in a separate file.
   # Colours used on MBIE pages seem to be 76797c (dark blue) 436976 (paler blue) 8cacbb (paler again)
   # dee7ec (very pale blue) CC9933 (sort of brown)
   tags$head(
      tags$style(HTML("
                      @import url('//fonts.googleapis.com/css?family=Nunito|Cabin:400,700');
                      
                      body {
                      font-family: 'Nunito';
                      color: #436976;
                      }
                      
                      h2 {
                      font-weight: 700;
                      line-height: 1.1;
                      color: #8cacbb;
                      }
                      
                      pop {
                      font-family: 'Nunito';
                      color: #CC9933;
                      }
                      
                      
                      .selectize-dropdown, .selectize-input { 
                      font-family: 'Nunito';
                      color:#436976;
                      }
                      
                      "))
      ),
   
   # Application title
   titlePanel("New Zealand tourism forecasts"),
   
      
         selectInput("country",
                     "Choose a country:",
                     choices = as.character(unique(forecasts$Country)))
      ,
   p("Click on a point for the exact value"),   
   fixedRow(
      column(width = 4,  ggvisOutput("TotalVisitorArrivals")),
      column(width=4),
      column(width = 4,  ggvisOutput("SpendPerDay")),
      column(width = 4,  ggvisOutput("AvLengthOfStay")),
      column(width=4),
      column(width = 4,  ggvisOutput("TotalVisitorSpend"))
   )
      

   
))
