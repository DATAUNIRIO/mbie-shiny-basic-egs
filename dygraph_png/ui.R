library(shiny)
library(dygraphs)

shinyUI(fluidPage(
   tags$head(
      tags$script(src = "dygraph-extra.js")
   ),
   
   tags$a(id = "dygraphDown", class = "btn btn-default shiny-download-link",
          icon("download"), "Download as PNG", download = "dygraph.png"),
   dygraphOutput("dygraph")
))
