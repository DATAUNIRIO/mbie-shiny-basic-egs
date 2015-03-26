library(ggvis)
library(dplyr)
library(scales)
library(tidyr)
library(shiny)
load("ivs.rda")

shinyServer(function(input, output, session) {
   output$TheText <- renderText(paste0("<h3>", input$country_choice, "</h3>"))
   
   ivs_data <- reactive({
      ivs %>%
         filter(Country == input$country_choice)
   })

   ivs_data %>%
      ggvis(x = ~TimePeriod, y = ~spend, stroke = ~spend) %>%
      layer_lines() %>%
      layer_text(text := ~Q) %>%
      bind_shiny("ivs_plot")

      
})
