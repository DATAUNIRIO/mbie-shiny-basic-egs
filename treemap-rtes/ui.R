library(shiny)
library(d3treeR)
fluidPage(
   tags$head(
      includeCSS("styles.css")
   ),
   fluidRow(
      h2("New Zealand Regional Tourism Estimates, by Regional Tourism Organisation")
      ),
   fluidRow(
      d3tree2Output("tree", width = "800px", height = "550px")
      )
   )
   
