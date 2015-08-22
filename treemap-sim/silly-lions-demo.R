library(shiny)
library(treemap)
library(d3treeR)


Var1 <- letters[1:5]
Var2 <- LETTERS[1:5]
Var3 <- c("Tiger", "Lion", "Bear", "Penguin", "Eagle", "Aardvark")

ThreeLevels <- expand.grid(Var1, Var2, Var3)
n <- nrow(ThreeLevels)
ThreeLevels$Size <- abs(rnorm(n, 12, 3))
ThreeLevels$Colour <- rnorm(n, 0, 1)

tm <- treemap(ThreeLevels, index = c("Var1", "Var2", "Var3"), 
              vSize = "Size", vColor = "Colour",
              type = "value", palette = "Spectral",
              fun.aggregate="weighted.mean")

tmd3 <- d3tree2(tm)            


shinyApp(
   ui = fluidPage(
      sidebarLayout(
         sidebarPanel(p("Hello world")),
         mainPanel(d3treeOutput("tree"))
      )
   ), 
   server = function(input, output) {
      output$tree <- renderD3tree2(tmd3)
   }
)