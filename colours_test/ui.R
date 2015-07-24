library(shiny)
library(ggvis)
library(dygraphs)

allplots = function(name){
   tagList(
      conditionalPanel(paste0("input.Barchk==false"), plotOutput(paste0(name, "Bar"))),
      conditionalPanel(paste0("input.MarketCompchk==false"), ggvisOutput(paste0(name, "MarketComp"))),
      conditionalPanel(paste0("input.Dygraphchk==false"), dygraphOutput(paste0(name, "Dygraph"), height = 400))
   )
}

shinyUI(fluidPage(
   tags$head(
      includeCSS("styles.css")
   ),
   
   fluidRow(
      h2("Colours Test"),
      tags$div(style = "font-size: larger; padding: 15px; width: 500px; float: left;",
         tags$p(paste("This app provides a comparison of MBIE colours, Tourism colours,",
                      "a choice of Brewer qualitative palettes,",
                      "and HCL, which provides colour from the CIE-LUV",
                      "color space in a way that meets the recommendation in bold on the right.")),
         tags$p(style = "font-weight: bold;", "Links"),
         tags$p(tags$a(href = "http://colorbrewer2.org/", "Color Brewer")),
         tags$p(tags$a(href = "https://en.wikipedia.org/wiki/Munsell_color_system", "Munsell color system")),
         tags$p(tags$a(href = "https://en.wikipedia.org/wiki/CIELUV", "CIELUV (Wikipedia article)")),
         tags$p(paste("For the first row of graphs, all the boxes are of equal size",
                      "Check if any box seems larger or smaller than the others.",
                      "If that's the case, then the colours are applying bias.")),
         tags$p(paste("The second row is of actual data, showing RTE Market Composition.")),
         tags$p(paste("The third row is also of actual data, showing some RTI data,",
                      "though the legend have been disabled for space.",
                      "As the areas no longer correspond to data, colour bias is less important,",
                      "though it can still have an effect in making some series stand out more.",
                      "As the lines are thin, saturated colours are desired. Consider changing",
                      "the Brewer palette, or the HCL Chroma and Luminance numbers."))
      ),
      tags$div(style = "background-color: #F1F1F1; padding: 15px; margin-right: 20px; width: 600px; float: left;",
      tags$p(tags$em(paste("Text taken from",
"Ihaka, R. (2003). Colour for Presentation Graphics, Proceedings of",
"the 3rd International Workshop on Distributed Statistical",
"Computing (DSC 2003), March 20-22, 2003, Technische Universität",
"Wien, Vienna, Austria. URL:",
"http://www.ci.tuwien.ac.at/Conferences/DSC-2003"))),
      tags$div(style = "font-size: larger;",
      tags$p(paste(
"Choosing a good set of colours means addressing both perceptual and aesthetic",
"issues. The perceptual issues usually impose clear constraints on colour choices.",
"Some examples of these constraints follow:")),
      tags$ul(style = "line-height: 20px;", tags$li(paste(
"It is best to avoid large areas of high-chroma colours in graphs which must",
"hold a users attention for extended periods. This is because such colours tend",
"to produce after-image effects which are can be distracting.")),
      tags$li(paste(
"If the size of the areas presented in a graph is important, then the areas",
"should be rendered with colours of similar luminance. This is because lighter",
"colours tend to make areas look larger than darker colours.")),
      tags$li(paste(
"When colours are used to indicate group membership, the colours should be",
"easy to distinguish."))),
      tags$p(paste(
"Aesthetic considerations are much harder to state, but we would do well to heed",
"Munsell’s advice and choose colours in a methodical, balanced way. Most of these suggestions",
"amount to choosing colours at equally spaced points along smooth paths through",
"his (perceptually uniform) colour space. This is qualitatively the same type of",
"recommendation made by Cynthia Brewer.")),
      tags$p(paste(
"There is a simple way of choosing colours which meets all the constraints above.",
"The method can be stated simply as follows.")),
      tags$p(style = "font-weight: bold;", paste("In a perceptually uniform space,",
"choose colours which have equal luminance and chroma and correspond to set of",
"evenly spaced hues."))
      )),
      tags$div(style = "float: left;", HTML('<img alt="File:Munsell-system.svg" src="//upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Munsell-system.svg/600px-Munsell-system.svg.png" srcset="//upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Munsell-system.svg/900px-Munsell-system.svg.png 1.5x, //upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Munsell-system.svg/1200px-Munsell-system.svg.png 2x" data-file-width="600" data-file-height="600" height="600" width="600">'))
   ),
   fluidRow(column(3,
      h3("MBIE"),
      checkboxInput("Barchk", "Hide basic boxes"),
      checkboxInput("MarketCompchk", "Hide Market Composition plots"),
      checkboxInput("Dygraphchk", "Hide RTI Time Series plots")
   ), column(3,
      h3("Tourism")
   ), column(3,
      h3("Brewer"),
      selectInput("BrewerName", "Palette", c("Accent", "Dark2", "Paired", "Pastel1", "Pastel2", "Set1", "Set2", "Set3"), selected = "Pastel1", selectize = FALSE)
   ), column(3,
      h3("HCL"),
      sliderInput("HCLHue", "Hue Range", 0, 360, c(0, 270)),
      sliderInput("HCLc", "Chroma", 0, 100, 35),
      sliderInput("HCLl", "Luminance", 0, 100, 85)
   )),
   fluidRow(
      column(3,
      allplots("MBIE")
   ), column(3,
      allplots("Tourism")
   ), column(3,
      allplots("Brewer")
   ), column(3,
      allplots("HCL")
   ))
))
