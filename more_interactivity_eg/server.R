library(ggvis)
library(dplyr)
library(scales)
library(tidyr)
library(shiny)


shinyServer(function(input, output, session) {
   output$TheText <- renderText("Hello")

   output$results = renderPrint({input$mydata})
      output$Image <- renderText(paste0("<img src='images/measure", 
                                        input$mydata, ".svg' style='width:100px'>"))
      
})
