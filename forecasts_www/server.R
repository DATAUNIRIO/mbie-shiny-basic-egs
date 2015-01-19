library(ggvis)
library(dplyr)
library(scales)
library(reshape2)
library(shiny)

load("forecasts.rda")

set.seed(1233)
cocaine <- cocaine[sample(1:nrow(cocaine), 500), ]
cocaine$id <- seq_len(nrow(cocaine))



shinyServer(function(input, output) {

   lb <- linked_brush(keys = cocaine$id, "red")
   
   cocaine %>%
      ggvis(~weight, ~price, key := ~id) %>%
      layer_points(fill := lb$fill, fill.brush := "red", opacity := 0.3) %>%
      lb$input() %>%
      set_options(width = 300, height = 300) %>%
      bind_shiny("plot1") # Very important!
   
   
   # A subset of cocaine, of only the selected points
   selected <- lb$selected
   cocaine_selected <- reactive({
      cocaine[selected(), ]
   })
   
   cocaine %>%
      ggvis(~potency) %>%
      layer_histograms(width = 5, boundary = 0) %>%
      add_data(cocaine_selected) %>%
      layer_histograms(width = 5, boundary = 0, fill := "#dd3333") %>%
      set_options(width = 300, height = 300) %>%
      bind_shiny("plot2")
   
   output$grid_ggvis <- renderUI({
      
      p1 <- ggvisOutput("plot1")
      p2 <- ggvisOutput("plot2")
      
      # no graphs shown
      # HTML(paste0("<table><td>",p1,"</td><td>",p2,"</td></table>"))
      
      # clunky but seems to work
      html1 <- HTML("<table><td>")
      html2 <- HTML("</td><td>")
      html3 <- HTML("</td></table>")
      list(html1,p1,html2,p2,html3)
   })
   
   
   
   
   
   
   
   
   
   my_forecasts <- reactive({
      return(filter(forecasts, Country == "Australia")[ , c("Year",
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
      bind_shiny("TotalVisitorArrivals") 
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~SpendPerDay, stroke = ~Type) %>%
      layer_lines() %>%
      layer_points(fill = ~Type) %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Spend per day", format="$d", title_offset = 65) %>%
      add_tooltip(function(input){
         paste("$", format(round(input$SpendPerDay, -1), big.mark=","),
               "<br>per day</br>")
      }, on="click") %>%
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
      bind_shiny("AvLengthOfStay") 
   
   my_forecasts %>%
      ggvis(x = ~Year, y = ~TotalVisitorSpend, stroke = ~Type) %>%
      layer_lines() %>%
      layer_points(fill = ~Type) %>%
      add_axis("x", title="", format="04d") %>%
      add_axis("y", title="Total spend ($m)", format="$d", title_offset = 65) %>%
      add_tooltip(function(input){
         paste("$", format(round(input$TotalVisitorSpend, -1), big.mark=","),
               "<br>million</br>")
      }, on="click") %>%
      bind_shiny("TotalVisitorSpend") 
   
output$test <- renderUI(list("TotalVisitorSpendRendered"))   

})
