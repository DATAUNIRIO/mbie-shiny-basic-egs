library(shiny)
library(ggvis)

load("RTEs.rda")

# Define UI for application that draws a histogram
shinyUI(fixedPage(
   
   # Application title
   titlePanel("New Zealand regional tourism estimates"),
   
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
