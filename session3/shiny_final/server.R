library(shiny)
library(ggvis)
library(dplyr)
library(tidyr)
load("ivs.rda")
load("dimensions.rda")

shinyServer(function(input, output, session) {
   # updateSelectInput(session, "MyVariable", selected = input$counter - trunc(input$counter))
   
   
   #===================Define the headings====================================
   output$Heading1 <-renderText(paste0("<h3>", 
                                      input$MyCountry, 
                                      " : ",
                                      input$MyVariable,
                                      " (quarterly) </h3>"))
   
   output$Heading2 <-renderText(paste0("<h3>",
                                       input$MyVariable,
                                       " in year to ", max(ivs1$Year),
                                       " quarter ", unique(ivs1[ivs1$Period == max(ivs1$Period) , "Qtr"]),
                                       input$counter,
                                       "</h3>"))
   
   
   
   #===================Time series plot==============
   #---------Define the data we need---------------
   TheData <- reactive({
      tmp <- ivs1 %>%
         filter(CountryGrouped %in% input$MyCountry & Variable %in% input$MyVariable)
      return(tmp)
   })
   
   #---------Define the plot and send to the UI---------------
   TheData %>%
       ggvis(x = ~Period, y = ~Value, stroke = ~CountryGrouped) %>%
       layer_lines() %>%
       layer_smooths() %>%
       set_options(width = 400, height = 250) %>%
       add_axis("x", title="", format="04d") %>%
      add_axis("y", title="") %>%
      bind_shiny("TimeSeriesPlot")
    
   #========================Dot chart=========================
   #---------Define the data we need---------------
   TheVariableData <- reactive({
      tmp <- ivs2 %>%
         filter(Variable %in% input$MyVariable) 
      
      return(tmp)
   })
   
   
   #----------define some functions for use later in mouse events-------------
   dot_tooltips <- function(data){
      if(is.null(data)) return(NULL)
      tmp <- data
      tmp$Value <- round(tmp$Value, -1)
      paste0(names(tmp), ": ", format(tmp, big.mark=","), collapse = "<br />")
   }
   
   dot_click <- function(data){
      if(is.null(data)) return(NULL)
      updateSelectInput(session, "MyCountry", selected = data$CountryGrouped)
      
      # we still want the tooltip on the screen, so call that function again:
      dot_tooltips(data)
   }
   
   #---------Define the plot and send to the UI---------------
   TheVariableData %>%
      ggvis(y = ~CountryGrouped, x = ~Value, fill = ~CountryGrouped) %>%
      layer_points(size := 400) %>%
      set_options(width=400, height=400) %>%
      add_axis("y", title="") %>%
      add_axis("x", title="") %>%
      add_tooltip(dot_tooltips, on = "hover") %>%
      add_tooltip(dot_click, on = "click") %>%
      bind_shiny("VariablePlot")
   


      
})
