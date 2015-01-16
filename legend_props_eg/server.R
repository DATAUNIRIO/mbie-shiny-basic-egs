library(ggvis)
library(shiny)


shinyServer(function(input, output) {
   mtcars %>%
      ggvis(x = ~wt, y = ~mpg, fill = ~gear, shape = ~as.factor(cyl) ) %>%
      layer_points() %>%
      add_legend("fill", properties = legend_props(legend = list(y = 150))) %>%
      add_legend("shape", properties = legend_props(legend = list(y = 50))) %>%
      bind_shiny("LegendProb") 
   
   

})
