library(ggvis)
library(shiny)
library(leaflet)
library(dplyr)

# Import a map from the internet
m <- leaflet()  %>% addTiles() %>%  setView(174.7772, -41.2889, zoom = 6) 

# Load in the data
load("visits_by_yr_by_country.rda")

shinyServer(function(input, output) {
   the_data <- visited_m_all %>%
      filter(Year == 2013 & Country == "Australia")
   
   
   # Print that map, centering it in Wellington and adding circles proportionate to number of nights and with 
   map <- m %>%
            addCircleMarkers( the_data$Longitude, 
                              the_data$Latitude, 
                              radius = sqrt(the_data$Nights / max(the_data$Nights)) * 50,
                              popup = the_data$PopUp)
   
   
   output$myMap <- renderLeaflet(map)
   

})
