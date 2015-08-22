library(shiny)
library(d3treeR)

load("rtes_treemap.rda")
shinyServer(function(input, output){
   output$tree <- renderD3tree2(rtes_treemap)
   
}
)