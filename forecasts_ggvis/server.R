library(ggvis)
library(dplyr)
library(scales)
library(reshape2)
library(shiny)

load("forecasts.rda")
forecasts$SurveyResponseID <- NULL
forecasts$ForecastYear <- NULL
forecasts$TotalVisitorDays <- NULL

tmp <- forecasts %>% 
         group_by(Year, Type) %>%
         summarise(TotalVisitorArrivals = sum(TotalVisitorArrivals),
                   SpendPerDay = mean(SpendPerDay),
                   AvLengthOfStay = mean(AvLengthOfStay),
                   TotalVisitorSpend = sum(TotalVisitorSpend))
tmp$Country <- "All combined"

forecasts <- rbind(tmp, forecasts)

pal <- c("#5C788F", "#A8B50A")

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
      layer_points(fill = ~Type) %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Total visitor arrivals", title_offset = 65) %>%
      add_tooltip(function(input){
         paste(format(round(input$TotalVisitorArrivals, -3), big.mark=","),
               "<br>arrivals</br>")
         }, on="click") %>%
      scale_ordinal("fill", range = pal) %>%
      scale_ordinal("stroke", range = pal) %>%
      set_options(width = 400, height = 250) %>%
      bind_shiny("TotalVisitorArrivals") 
   
   my_forecasts %>%
      filter(!is.na(SpendPerDay)) %>%
      ggvis(x = ~Year, y = ~SpendPerDay, stroke = ~Type) %>%
      layer_lines() %>%
      layer_points(fill = ~Type) %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Spend per day", format="$d", title_offset = 65, orient="right") %>%
      add_tooltip(function(input){
         paste("$", format(round(input$SpendPerDay, -1), big.mark=","),
               "<br>per day</br>")
      }, on="click") %>%
      scale_ordinal("fill", range = pal) %>%
      scale_ordinal("stroke", range = pal) %>%
      set_options(width = 380, height = 250) %>%
      hide_legend(c("stroke", "fill")) %>%
      bind_shiny("SpendPerDay") 
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~AvLengthOfStay, stroke = ~Type) %>%
      layer_lines() %>%
      layer_points(fill = ~Type) %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Average length of stay", format="d", title_offset = 65) %>%
      add_tooltip(function(input){
         paste(format(round(input$AvLengthOfStay, 1), big.mark=","),
               "<br>days</br>")
      }, on="click") %>%
      scale_ordinal("fill", range = pal) %>%
      scale_ordinal("stroke", range = pal) %>%
      set_options(width = 400, height = 250) %>%
      bind_shiny("AvLengthOfStay") 
   
   my_forecasts %>%
      filter(!is.na(SpendPerDay)) %>%
      ggvis(x = ~Year, y = ~TotalVisitorSpend, stroke = ~Type) %>%
      layer_lines() %>%
      layer_points(fill = ~Type) %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Total spend ($m)", format="$d", title_offset = 65, orient="right") %>%
      add_tooltip(function(input){
         paste("$", format(round(input$TotalVisitorSpend, -1), big.mark=","),
               "<br>million</br>")
      }, on="click") %>%
      scale_ordinal("fill", range = pal) %>%
      scale_ordinal("stroke", range = pal) %>%
      set_options(width = 380, height = 250) %>%
      hide_legend(c("stroke", "fill")) %>%
      bind_shiny("TotalVisitorSpend") 
   
   

})
