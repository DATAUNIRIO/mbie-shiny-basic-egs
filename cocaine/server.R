library(ggvis)
library(dplyr)
library(scales)
library(reshape2)
library(shiny)

set.seed(1233)
cocaine <- cocaine[sample(1:nrow(cocaine), 500), ]
cocaine$id <- seq_len(nrow(cocaine))



shinyServer(function(input, output) {

   lb <- linked_brush(keys = cocaine$id, "red")
   
   cocaine %>%
      ggvis(~weight, ~price, key := ~id) %>%
      layer_points(fill := lb$fill, fill.brush := "red", opacity := 0.3) %>%
      lb$input() %>%
      set_options(width = 300, height = 300) %>%
      bind_shiny("plot1") # Very important!
   
   
   # A subset of cocaine, of only the selected points
   selected <- lb$selected
   cocaine_selected <- reactive({
      cocaine[selected(), ]
   })
   
   cocaine %>%
      ggvis(~potency) %>%
      layer_histograms(width = 5, boundary = 0) %>%
      add_data(cocaine_selected) %>%
      layer_histograms(width = 5, boundary = 0, fill := "#dd3333") %>%
      set_options(width = 300, height = 300) %>%
      bind_shiny("plot2")
   
   output$grid_ggvis <- renderUI({
      
      p1 <- ggvisOutput("plot1")
      p2 <- ggvisOutput("plot2")
      
      # no graphs shown
      # HTML(paste0("<table><td>",p1,"</td><td>",p2,"</td></table>"))
      
      # clunky but seems to work
      html1 <- HTML("<table><td>")
      html2 <- HTML("</td><td>")
      html3 <- HTML("</td></table>")
      list(html1,p1,html2,p2,html3)
   })
   
   # a ggplot plot so we can check the basic setup is working
   output$ggp <- renderPlot(print(
      ggplot(mtcars, aes(x=disp, y=mpg)) + geom_point()
      ))
   
})
