library(shiny)
library(ggvis)
library(dplyr)

load("ivs.rda")
load("dimensions.rda")

shinyServer(function(input, output, session) {
   
   
      
   #===================Define the headings====================================
   output$Heading1 <-renderText(paste0("<h3>", 
                                      input$MyCountry, 
                                      " : ",
                                      input$MyVariable,
                                      " (quarterly) </h3>"))
   
   output$Heading2 <-renderText(paste0("<h3><u>",
                                       input$MyVariable,
                                       "</u> in year to ", max(ivs1$Year),
                                       " quarter ", unique(ivs1[ivs1$Period == max(ivs1$Period) , "Qtr"]),
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
      hide_legend(c("stroke")) %>%
      bind_shiny("TimeSeriesPlot")
    
   #========================Dot chart=========================
   #---------Define the data we need---------------
   TheVariableData <- reactive({
      tmp <- ivs2 %>%
         filter(Variable %in% input$MyVariable) 
      
      return(tmp)
   })
   
   
   #----------define some functions for use later in mouse events from the ggvis plot-------------
   dot_tooltips <- function(data){
      if(is.null(data)) return(NULL)
      tmp <- data
      tmp$Value <- round(tmp$Value, -1)
      paste0(format(tmp, big.mark=","), collapse = "<br />")
   }
   
   dot_click <- function(data){
      if(is.null(data)) return(NULL)
      updateSelectInput(session, "MyCountry", selected = data$CountryGrouped)
      
      # we still want the tooltip on the screen, so call that function again:
      dot_tooltips(data)
   }
   
   #------------------Reactive function for when the dotplot heading is clicked--------
   Monitoring <- observe({
      # we basically need a round number 1,2 or 3 that goes up one when the heading is clicked.
      # The javascript in the ui.R takes care of increasing the counter by 1 (counter++) each click.
      WhichVar <- max(1, round((input$counter / 5 - trunc(input$counter / 5)) * 5 + 1))
      
      updateSelectInput(session, "MyVariable", selected = AllVariables[WhichVar])
   })
   
   
   #---------Define the plot and send to the UI---------------
   TheVariableData %>%
      ggvis(y = ~CountryGrouped, x = ~Value, stroke = ~CountryGrouped, fill = ~CountryGrouped) %>%
      layer_points(size := 400) %>%
      set_options(width=400, height=400) %>%
      add_axis("y", title="") %>%
      add_axis("x", title="") %>%
      add_tooltip(dot_tooltips, on = "hover") %>%
      add_tooltip(dot_click, on = "click") %>%
      bind_shiny("VariablePlot")
   


      
})
