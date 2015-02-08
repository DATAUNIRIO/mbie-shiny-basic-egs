library(ggvis)
library(dplyr)
library(scales)
library(reshape2)
library(shiny)

load("itm.rda")

pal <- c("#5C788F", "#A8B50A")

shinyServer(function(input, output) {
   legit_vars <- reactive({
      filter(itm, ValueType == input$MyValueType)$variable %>% 
         unique()
   })
   
   # Define reactive part of UI
   output$select_variable <- renderUI({
      selectInput(inputId = "MyVariable", 
                  label = h3("Choose"),
                  choices = legit_vars(),
                  selected = legit_vars()[1])
      })
   # Define data
      my_itm <- reactive({
      tmp <- itm %>%
         filter(ValueType == input$MyValueType) 
      if(!is.null(input$MyVariable)){
         tmp %>% filter(variable == input$MyVariable)
      } else {
         tmp %>% filter(variable == legit_vars()[1])
      }
         
   })
   
   # Draw plot   
      the_plot <- reactive({
         my_itm %>%
            ggvis(x = ~TimePeriod, y = ~value) %>%
            layer_lines() %>%
            add_axis("x", title="", format="04d") %>%
            add_axis("y", title=input$MyVariable, title_offset = 65) %>%
            set_options(width = 800, height = 250) 
      })
         
         
         the_plot %>% bind_shiny("ITM_Plot")   
  
})