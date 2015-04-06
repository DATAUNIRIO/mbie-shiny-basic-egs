library(shiny)
library(ggvis)

# next two lines could be more efficiently done beforehand in prep.R
load("dimensions.rda")

# Read in the CSS as a text file.  Not the most efficient way to do this but illustrates one technique.
MyCSS  <- scan("MBIEcss.txt", what=character())

# Define UI for application that draws a histogram
shinyUI(fixedPage(
   
   # HTML head
   tags$head(
      tags$style(HTML(MyCSS)),
      tags$script('var counter = 1;')
      ), # end of head
     h2("International visitor spend"),
     
   
   # Columns divide the page into 12
   column(7, 
          htmlOutput("Heading1"),
          ggvisOutput("TimeSeriesPlot"),
          selectInput("MyCountry", "Choose a country group", 
                      choices = AllCountries, 
                      selected = "Australia",
                      multiple = FALSE,
                      selectize = FALSE),
          
          selectInput("MyVariable", "Choose a variable", 
                      choices = AllVariables, 
                      selectize=FALSE)
   ),
   
   column(5,
          htmlOutput("Heading2"),
          ggvisOutput("VariablePlot")
          ),
          
          
   tags$script('
    document.getElementById("Heading2").onclick = function() {
counter ++;      
Shiny.onInputChange("counter", counter);
      };
  ')   
 
   

         
)
)
