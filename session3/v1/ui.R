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
      tags$style(HTML(MyCSS))             # defines the CSS for look and feel
      ), # end of head
     h2("International visitor survey - interactivity demonstration / training"),
     
          htmlOutput("Heading1"),
          ggvisOutput("TimeSeriesPlot"),
          selectInput("MyCountry", "Choose a country of permanent residence", 
                      choices = AllCountries, 
                      selected = "Australia",
                      multiple = FALSE,
                      selectize = FALSE),
          
          selectInput("MyVariable", "Choose a variable", 
                      choices = AllVariables, 
                      selectize=FALSE),
      
          htmlOutput("Heading2"),
          ggvisOutput("VariablePlot")
          

         
)
)
