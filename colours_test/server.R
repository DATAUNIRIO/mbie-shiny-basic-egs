library(shiny)
library(ggvis)
library(dygraphs)
library(zoo)
library(xts)
library(RColorBrewer)
source("mbie_tourism_cols.R")
## Test data
test_dat = matrix(rep(10, 5 * 7), ncol = 5)
colnames(test_dat) = LETTERS[1:5]
## RTE Market Composition data
load("rte_market_comp.rda")
rte_ncat = length(levels(rte_market_comp$Product))
rte_sub = rte_market_comp[1:(rte_ncat * 5),]
rte_sub$Origin = factor(rte_sub$Origin)
## RTI data
rti_dat = read.csv("RTI-Download.csv", check.names = FALSE)
rti_sub = rti_dat[,1:8]
rti_dyquick =
   function(pal, labelsDiv = NULL, downID = NULL){
      sub_tla = rti_sub[,-1]
      dates = as.Date(rti_sub[,1])
      todraw = "Both"
      
      list_tla = list()
      
      if(todraw == "Obs" || todraw == "Both"){
         list_tla[[1]] = sub_tla
      }
      if(todraw == "RA" || todraw == "Both"){
         roll_tla = apply(sub_tla, 2, function(x) rollmean(x, 12, fill = NA, align = "right"))
         colnames(roll_tla) = paste(colnames(roll_tla), "(12-mth)")
         list_tla[[2]] = roll_tla
      }
      
      merged_tla = xts(do.call(cbind, list_tla), dates)
      
      ## Init
      out_dy = dygraph(merged_tla, group = "dygraph")
      
      ## Plot each series
      for(curvar in colnames(sub_tla)){
         curcol = as.vector(pal[curvar])
         if(todraw == "Both"){
            out_dy = out_dy %>%
               dySeries(curvar, strokePattern = "dotted", color = curcol) %>%
               dySeries(paste(curvar, "(12-mth)"), strokeWidth = 3, color = curcol) %>%
               dyHighlight(highlightSeriesOpts = list(strokeWidth = 5, strokeBorderWidth = 2))
         } else if(todraw == "Obs"){
            out_dy = dySeries(out_dy, curvar, color = curcol) %>%
               dyHighlight(highlightSeriesOpts = list(strokeWidth = 3, strokeBorderWidth = 2))
         } else if(todraw == "RA"){
            out_dy = dySeries(out_dy, paste(curvar, "(12-mth)"), color = curcol) %>%
               dyHighlight(highlightSeriesOpts = list(strokeWidth = 3, strokeBorderWidth = 2))
         }
      }
      
      ## Finish
      out_dy = out_dy %>%
         dyRangeSelector(dateWindow = c("2013-05-31", "2015-05-31")) %>%
         dyLegend(show = "always", labelsDiv = labelsDiv, labelsSeparateLines = TRUE) %>%
         dyOptions(rightGap = 25) %>%
         dyLegend(show = "never")
      
      ## Add handling for downloading
      if(!is.null(downID))
         out_dy = dyCallbacks(out_dy, drawCallback = dygraphDownload(downID))
      
      renderDygraph(out_dy)
   }

shinyServer(function(input, output){
   cols = list(
      MBIE = function(x) mbie.cols(1:x),
      Tourism = function(x) substr(tourism.cols(1:x), 0, 7),
      Brewer = function(x) brewer.pal(x, input$BrewerName),
      HCL = function(x) hcl(seq(input$HCLHue[1], input$HCLHue[2], length = x), c = input$HCLc, l = input$HCLl)
   )
   
   ## Use local inside loop because shiny is dumb and lazy
   for(curname in names(cols)) local({
      namelocal = curname
      ## Barplot
      output[[paste0(namelocal, "Bar")]] = renderPlot({
         barplot(test_dat, col = cols[[namelocal]](7))
      })
      ## Market Composition
      observe({
         pal = cols[[namelocal]](rte_ncat)
         rte_sub %>%
            ggvis(x = ~Origin, y = ~Spend, fill = ~Product) %>%
            scale_ordinal("fill", range = pal) %>%
            hide_legend("fill") %>%
            layer_bars() %>%
            set_options(width = "auto", height = 400, duration = 0, renderer = "canvas") %>%
            add_tooltip(function(input){
               if(is.null(input)) return(NULL)
               paste0("<b>", input$x_, "</b><br/>",
                      input$Product, " (",
                      round((input$stack_upr_ - input$stack_lwr_) * 100), "%)")
            }) %>%
         bind_shiny(paste0(namelocal, "MarketComp"))
      })
      ## Dygraph
      observe({
         pal = cols[[namelocal]](7)
         names(pal) = colnames(rti_sub[,-1])
         output[[paste0(namelocal, "Dygraph")]] = rti_dyquick(pal)
      })
   })
})
