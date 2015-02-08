library(shiny)
library(ggvis)
load("itm.rda")

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
   h2("New Zealand International Travel and Migration data"),
   fixedRow(
      
      column(width=6, 
         selectInput("MyValueType", 
                  h3("Select something to look at"),
                  choices=unique(itm$ValueType))
      ),
      
      column(width =6, 
         uiOutput("select_variable")
         )
   ),
   fixedRow(
      ggvisOutput("ITM_Plot")
      )
   
   
   
))
   