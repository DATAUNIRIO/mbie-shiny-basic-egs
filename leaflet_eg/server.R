library(shiny)
library(leaflet)
library(dplyr)

# Import a map from the internet
m <- leaflet()  %>% addTiles() %>%  setView(174.7772, -41.2889, zoom = 6) 

# Load in the data
load("visited_m_combined.rda")

shinyServer(function(input, output) {
   the_data <- reactive({
      if(input$yeartype == "Single year at a time") {
         tmp <- visited_m_combined %>% filter(Year == input$year & Country == input$country)
      } else {
         tmp <- visited_m_av %>% filter(Country == input$country)
      }
      return(tmp)
   })
   
   
   # Print that map, centering it in Wellington and adding circles proportionate to number of nights and with 
   map <- reactive({
      m %>%
            addCircleMarkers( the_data()$Longitude, 
                              the_data()$Latitude, 
                              radius = sqrt(the_data()$Nights / 2000000) * 50,
                              popup = the_data()$PopUp)
   })
   
   
   TheTitle <- reactive({
      if(input$country == "All countries"){
         tmp_title <- "all countries"
      } else {
         tmp_title <- input$country
      }
      if(input$yeartype == "Single year at a time"){
         return(paste("<h2>Overnight stays by visitors from", tmp_title, "in", input$year, "</h2>"))
      } else {
         return(paste("<h2>Overnight stays from", tmp_title, "2008-2013 average</h2>"))
      }
      
      
   })
   
   output$Title <- renderText(TheTitle())
      
   output$myMap <- renderLeaflet(map())
   

})
