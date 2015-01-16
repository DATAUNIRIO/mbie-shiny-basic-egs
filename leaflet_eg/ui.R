library(shiny)
library(ggvis)
library(leaflet)

load("countries_and_years.rda")

shinyUI(fixedPage(
   
   h1("Visits"),
   fixedRow(
      column(width=4, 
             selectInput("country", "Country of origin", choices = countries)
             ),
      column(width=4, 
             p("")
             #  submitButton("Get new map")
      ),
      column(width=4, 
             selectInput("year", "Year of visit", choices = years)
      )
      
      ),
                
   fixedRow(
      leafletOutput('myMap', height=700)
   )
      
      
   )
   
)
