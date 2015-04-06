library(shiny)
library(ggvis)
library(dplyr)
library(tidyr)
load("ivs.rda")

shinyServer(function(input, output, session) {
   output$Heading1 <-renderText(paste0("<h3>", 
                                      input$MyCountry, 
                                      " : ",
                                      input$MyVariable,
                                      " (quarterly) </h3>"))
   
   output$Heading2 <-renderText(paste0("<h3>",
                                       input$MyVariable,
                                       " in year to ", max(ivs1$Year),
                                       " quarter ", unique(ivs1[ivs1$Period == max(ivs1$Period) , "Qtr"]),
                                       "</h3>"))
   
   
   # Total data - used for the time series plots
   TheData <- reactive({
      tmp <- ivs1 %>%
         filter(CountryGrouped %in% input$MyCountry & Variable %in% input$MyVariable)
      return(tmp)
   })

   # Variable data - used for the dot plots
   TheVariableData <- reactive({
      tmp <- ivs2 %>%
         filter(Variable %in% input$MyVariable) 
            
      return(tmp)
   })
   
   
    TheData %>%
       ggvis(x = ~Period, y = ~Value, stroke = ~CountryGrouped) %>%
       layer_lines() %>%
       layer_smooths() %>%
       set_options(width = 400, height = 250) %>%
       add_axis("x", title="", format="04d") %>%
      add_axis("y", title="") %>%
      bind_shiny("TimeSeriesPlot")
    
   
   TheVariableData %>%
      ggvis(y = ~CountryGrouped, x = ~Value, fill = ~CountryGrouped) %>%
      layer_points(size := 400) %>%
      set_options(width=400, height=400) %>%
      add_axis("y", title="") %>%
      add_axis("x", title="") %>%
      bind_shiny("VariablePlot")
   
   

      
})
