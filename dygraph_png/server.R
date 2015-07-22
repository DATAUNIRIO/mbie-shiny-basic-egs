library(shiny)
library(dygraphs)

shinyServer(function(input, output){
   output$dygraph = renderDygraph({
      lungDeaths = cbind(mdeaths, fdeaths)
      dygraph(lungDeaths, main = "Dygraph exporting to PNG Example") %>%
         dyRangeSelector() %>%
         dyCallbacks(drawCallback = "function(dygraph){$('#dygraphDown').attr('href', Dygraph.Export.asCanvas(dygraph).toDataURL());}")
   })
})
