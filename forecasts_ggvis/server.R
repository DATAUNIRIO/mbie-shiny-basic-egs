library(ggvis)
library(dplyr)
library(scales)
library(reshape2)
library(shiny)

load("forecasts.rda")

shinyServer(function(input, output) {
   my_forecasts <- reactive({
      return(filter(forecasts, Country == input$country)[ , c("Year",
                                                     "TotalVisitorArrivals",
                                                     "SpendPerDay",
                                                     "AvLengthOfStay",
                                                     "TotalVisitorSpend",
                                                     "Type")])
   })
      
   
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~TotalVisitorArrivals, stroke = ~Type) %>%
      layer_lines() %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Total visitor arrivals", format="d") %>%
      bind_shiny("TotalVisitorArrivals") 
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~SpendPerDay, stroke = ~Type) %>%
      layer_lines() %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Spend per day", format="$d") %>%
      bind_shiny("SpendPerDay") 
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~AvLengthOfStay, stroke = ~Type) %>%
      layer_lines() %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Average length of stay", format="d") %>%
      bind_shiny("AvLengthOfStay") 
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~TotalVisitorSpend, stroke = ~Type) %>%
      layer_lines() %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Total spend", format="$d") %>%
      bind_shiny("TotalVisitorSpend") 
   
   

})
