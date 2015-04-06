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
      tags$style(HTML(MyCSS)),             # defines the CSS for look and feel
      tags$script('var counter = 1;')      # initiates the counter variable for counting heading clicks
      ), # end of head
     h2("International visitor survey - interactivity demonstration / training"),
     
   
   # Columns divide the page into 12
   column(7, 
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
          
          HTML("<p>Source: MBIE, <i>International Visitor Survey</i></p>
               <p>Caution - under development and being used for both development and training purposes.  
               Not all data are checked.</p>")
   ),
   
   column(5,
          htmlOutput("Heading2"),
          ggvisOutput("VariablePlot"),
          p("Click on a dot to select that country of permanent residence; 
            and on the heading of this chart to cycle through different variables of interest")
          ),
          

   
   # we finish with a bit of javascript that counts how often the div called Heading2 has
   # been clicked; and pass this back to server.R which will see it as input$counter.
   tags$script('
    document.getElementById("Heading2").onclick = function() {
      counter ++;      
      Shiny.onInputChange("counter", counter);
      };
  ')   
 
   

         
)
)
