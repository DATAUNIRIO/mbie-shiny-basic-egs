library(shiny)
library(ggvis)

shinyUI(fixedPage(
   
   # Application title
   titlePanel("Legend properties go missing"),
                
             ggvisOutput("LegendProb"),
      
             p("The legends are displaced (y = 50 and y = 150) in a straight R session, but
                when rendered in Shiny they move both back up to the top right corner.")
             
      
   )
   
)
