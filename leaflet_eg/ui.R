library(shiny)
library(ggvis)
library(leaflet)
shinyUI(fixedPage(
   
   h1("Visits in 2013"),
                
   leafletOutput('myMap', height=800)
      
      
   )
   
)
