library(shiny)
library(ggvis)

load("RTEs.rda")

shinyUI(fixedPage(
   tags$head(
      tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Dosis|Cabin:400,700');

      body {
         font-family: 'Dosis';
         color: #436976
      }

      h2 {
        font-weight: 700;
        line-height: 1.1;
        color: #8cacbb;
      }

      pop {
         font-family: 'Dosis';
         color: #CC9933;
      }

      
      .selectize-dropdown, .selectize-input { 
            font-family: 'Dosis';
            color:#436976;
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
             h4(htmlOutput("BarTitle")),
             ggvisOutput("BarPlot"),
             hr(),
             h4(htmlOutput("TSTitle")),
             ggvisOutput("TSPlot"),
             hr(),
             
             p("Click on an area on the map to see the trend for that Territorial Authority")
             ),
      column(width = 7,  ggvisOutput("Map"))
      


      
   )
   
))
