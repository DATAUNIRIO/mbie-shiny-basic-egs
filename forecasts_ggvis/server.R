library(ggvis)
library(dplyr)
library(mbiedata)
library(scales)
library(reshape2)
library(shiny)

load("forecasts.rda")

shinyServer(function(input, output) {
   my_forecasts <- filter(forecasts, Country == "Australia")[ , c("Year",
                                                                       "TotalVisitorArrivals",
                                                                       "SpendPerDay",
                                                                       "AvLengthOfStay",
                                                                       "TotalVisitorSpend",
                                                                       "Type")]
   
   
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~SpendPerDay, stroke = ~Type) %>%
      layer_lines() %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Spend per day", format="$d") %>%
      bind_shiny("ggvis", "ggvis_ui") 


