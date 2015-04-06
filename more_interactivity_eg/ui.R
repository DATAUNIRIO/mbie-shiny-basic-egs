library(shiny)
library(ggvis)
library(dplyr)

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
                      }
                      
                      .floating-image{
                     left: 350px; top: 0px; position: absolute; width: 100px;
                      }
                      
                      "
      )),
      
      tags$script("var number = 1;")
      
   ), # end of head
     h2("Interactivity example"),
   htmlOutput("TheText"),

   HTML('<div id="mydiv", style="width: 50px; height :20px;
           left: 350px; top: 350px; opacity: 0.5;
           background-color: gray; position: absolute">Push me</div>'),

   htmlOutput("Image", class="floating-image"),

   

   
   # a shiny element to display unformatted text
   verbatimTextOutput("results"),
   
   # javascript code to send data to shiny server
   tags$script('
    document.getElementById("mydiv").onclick = function() {
number ++;      
Shiny.onInputChange("mydata", number);
      };
  ')
         
)
)
