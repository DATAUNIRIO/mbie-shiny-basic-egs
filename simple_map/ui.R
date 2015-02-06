library(shiny)
library(ggvis)

load("RTEs.rda")

shinyUI(fixedPage(
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
             }

    "))
   ),
   
   
   
   # Application title
   h2("New Zealand regional tourism estimates"),
   
   fixedRow(
      column(width = 5,
             selectInput("product",
                         "Choose a product:",
                         choices = as.character(unique(RTEs$Product)),
                         width = '100%'),
             hr(),
             h3(htmlOutput("BarTitle")),
             ggvisOutput("BarPlot"),
             hr(),
             h3(htmlOutput("TSTitle")),
             ggvisOutput("TSPlot"),
             hr(),
             
             p("Click on an area on the map to see the trend for that Territorial Authority"),
             
             HTML(
               "<p>We can do nicely MBIE-style formatted lists</p>
               <ul>
                  <li>Hello</li>
                  <li>Hello again</li>
               </ul>"
               
               )
      ),
      h3(htmlOutput("MapTitle")),
      column(width = 7,  ggvisOutput("Map"))
      


      
   )
   
))
