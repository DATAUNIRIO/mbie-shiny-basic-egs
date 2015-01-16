library(shiny)
library(ggvis)
library(leaflet)

load("countries_and_years.rda")

shinyUI(fixedPage(
   
   h1("Visits"),
   fixedRow(
      column(width=6, 
             selectInput("country", "Country of origin", choices = countries)
             ),
      column(width=3),
      column(width=3, 
             sliderInput("year", "Year of visit", value = max(years), min = min(years), max=max(years), step = 1,
                         format = "####", animate=TRUE)
            )
   ),
                
   fixedRow(
      leafletOutput('myMap', height=700)
   ),
   fixedRow(
      p("Click on circles to get the number of visitor nights; and use mouse or smartphone screen to zoom in and out.")
      )
   
      
      
   )
   
)
