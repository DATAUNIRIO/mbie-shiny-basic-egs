library(shiny)
library(leaflet)

load("countries_and_years.rda")

shinyUI(fixedPage(
   # insert some CSS.  Down the track this would be stored in a separate file.
   tags$head(
      tags$style(HTML("
                      body {
                      font-family: 'Lucida Sans Unicode', 'Lucida Grande', Verdana, Lucida, Helvetica, Arial, Calibri, sans-serif;
                      color: rgb(0,0,0);
                      font-size: 12.1px;
                      line-height: 18.15px;
                      margin-bottom: 9.075px; 
                      list-style-image: url(http://www.mbie.govt.nz/bullet_double_green_8x8.png);
                      }
                      
                      h2 {
                      font-size:20px;
                      line-height: 24px;
                      color: rgb(0, 139, 198);
                      }
                      
                      
                      h3 {
                      font-size:15px;
                      line-height: 18px;
                      color: rgb(0, 139, 198);
                      }
                      
                      .selectize-dropdown, .selectize-input, label { 
                      font-weight: normal;   
                      }
                      
                      pop {
                      color: #CC9933;
                      }
                      "
      ))),
   
   
   
   
  
   
   
   
   
   h2(htmlOutput("Title")),
   fixedRow(
      column(width=6, 
             selectInput("country", "Country of origin", choices = countries, selected = "All countries")
             ),
      column(width=3,
             radioButtons("yeartype", label = "", 
                          choices = c("Single year at a time", "Average 2009 - 2013"))
             ),
      column(width=3, 
             conditionalPanel("input.yeartype == 'Single year at a time'",
                              sliderInput("year", "Year of visit", value = max(years), 
                                          min = min(years), max=max(years), step = 1,
                                          format = "####", animate=TRUE)
             )
            )
   ),
                
   fixedRow(
      leafletOutput('myMap', height=700)
   ),
   fixedRow(
      HTML("<P>Click on circles to get the number of visitor nights; and use mouse or smartphone screen to zoom in and out.
        Estimates of locations visited come from the International Visitor Survey by 
        Ministry of Business, Innovation and Employment.  Estimates are subject to uncertainty from small sample 
        sizes and should be treated as only indicative in most cases.  See 
         <a href='http://www.med.govt.nz/sectors-industries/tourism/tourism-research-data/international-visitor-survey'>
         the survey's website</a> for more 
        details.</P>")
      )
   
      
      
   )
   
)
