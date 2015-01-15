library(ggvis)
library(dplyr)
library(plyr)
library(shiny)

load("RTEs.rda")
load("ta_simpl_gg.rda")

RTEs$TA <- gsub(" District", "", RTEs$Territorial_Authority)
RTEs$TA <- gsub(" City", "", RTEs$TA)

CAGR <- function (ratio, period) {
   round((exp(log(ratio)/period) - 1) * 100, 1)
}

shinyServer(function(input, output) {


   
   rte_sum <- reactive({ddply(subset(RTEs, Product == input$product), .(Territorial_Authority), summarise,
                    SpendLatest = sum(Spend[YEMar == max(YEMar)]),
                    Growth3Yr = CAGR(sum(Spend[YEMar == max(YEMar)]) / 
                                     sum(Spend[YEMar == max(YEMar - 3)]), 4))
   })
   
   
   TheTA <- reactiveValues(TA = "Auckland")
   
   output$TSTitle <- renderText(paste0("<i>", input$product, "</i>", " tourist spend in ", TheTA$TA))
   output$BarTitle <- renderText(paste0("Product distribution of tourism spend in ", TheTA$TA))
   
   ts_data <- reactive({
      ddply(subset(RTEs, Product == input$product & TA == TheTA$TA), .(YEMar), summarise, Spend = sum(Spend))
   })
   
   bar_data <- reactive({
      ddply(subset(RTEs, TA == TheTA$TA & YEMar == max(YEMar)), .(Product), summarise, Spend = sum(Spend))
   })
   
   map_data <- reactive({
      merge(ta_simpl_gg, rte_sum(), by.x="FULLNAME", by.y="Territorial_Authority",
                     all.x=TRUE)
   })
   
   centres <- reactive({
      unique(map_data()[ , c("lat.centre", "long.centre", "SpendLatest")])
   })
   
   find_region <- function(x){
      # converts 'group' to 'region' by trimming off the numbers at the end
      for(i in 27:1){
         x <- gsub(paste0(".", i), "", as.character(x), fixed=TRUE)
      }
      return(x)
   }
   
   map_data %>%
   group_by(group) %>%
   ggvis(x = ~long, y = ~ lat) %>%
   layer_paths(fill = ~ Growth3Yr, stroke := "grey70") %>%
#       layer_points(x = ~ long.centre, y = ~lat.centre, size = ~ SpendLatest, 
#                    fill := NA,
#                    stroke := "red",
#                    data = centres) %>%
   hide_axis("x") %>% hide_axis("y") %>%
   hide_legend("size") %>%
   add_legend("fill", title= "Three year average growth (%)") %>%
  
   set_options(width = 625, height = 800, keep_aspect = TRUE) %>%
   handle_click(on_click = function(data, ...) {TheTA$TA <- find_region(data$group)}) %>%
   scale_numeric("fill", range=c("white", "blue")) %>%
   bind_shiny("Map") 
   
   ts_data %>%
   ggvis(x = ~YEMar, y = ~Spend) %>%
   layer_paths() %>%
   add_axis("x", title="", format="04d") %>%
   add_axis("y", title="Total spend ($m)", title_offset = 65) %>%
   set_options(width = 400, height = 200, keep_aspect = TRUE) %>%
   bind_shiny("TSPlot")
   
   bar_data %>%
   ggvis(y = ~ Product, x = ~Spend, fill = ~Product) %>%
   layer_points(size := 200) %>% 
   hide_legend("fill") %>%
   add_axis("y", title="") %>%
   add_axis("x", title="Spend ($m)", format="$dm") %>%
   set_options(width = 280, height = 200, keep_aspect = TRUE) %>% 
   bind_shiny("BarPlot")

})
   
