library(shiny)
library(ggvis)
library(dplyr)

load("forecasts.rda")
countries_list <- forecasts %>% 
   group_by(Country) %>%
   summarise(MaxArrivals = max(TotalVisitorArrivals)) %>%
   arrange(-MaxArrivals * (Country != "Other")) 

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
            font-family: 'Lucida Sans Unicode', 'Lucida Grande', Verdana, Lucida, Helvetica, Arial, Calibri, sans-serif;
            font-size: 11px;
            font-weight: normal;   
                      }"
      )),
      
      # this line is meant to disable the drop down for keyboards even if selectize=TRUE but doesn't work
      tags$script(HTML("$('.selectize-input input').prop('disabled', true);"))
      
      ),
   
   
   fixedRow(
      h2("New Zealand Tourism Forecasts 2014-2020"),
      column(width=4, 
         selectInput("country",
                     "Choose a country:",
                     choices = c("All combined", as.character(countries_list$Country)),
                     width="200px",
                     selected = "All combined",
                     selectize=FALSE)
   ),
      column(width=8, HTML("<P><BR>Click on a point for the exact value</BR></P>"))
   ),   
   fixedRow(
      column(width = 6, ggvisOutput("TotalVisitorArrivals")),
      column(width = 6, ggvisOutput("TotalVisitorSpend"))
      ),
   fixedRow(
      column(width = 6,  ggvisOutput("AvLengthOfStay")),
      column(width = 6,  ggvisOutput("SpendPerDay"))
   ),
   HTML("<i>Caution - average spend and length of stay for 'All combined' are unweighted averages for illustrative purposes.  Approximately right, but we'll get more precise when we do this for real in May 2015.")
   

   
))
