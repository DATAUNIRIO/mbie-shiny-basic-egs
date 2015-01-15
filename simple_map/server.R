library(ggvis)
library(dplyr)
map_data = ggplot2::map_data("state")
map_data %>% select(long, lat, group, order, region) %>% 
   group_by(group) %>% 
   ggvis(x = ~long, y = ~lat) %>% 
   layer_paths(fill = ~region) %>%
   hide_legend("fill") %>% 
   handle_click(on_click = function(data, ...) {
      state <- data$region
      print(state)})

load("RTEs.rda")
load("ta_simpl_gg.rda")

CAGR <- function (ratio, period) {
   round((exp(log(ratio)/period) - 1) * 100, 1)
}

rte_sum <- ddply(subset(RTEs, Product == "Accommodation"), .(Territorial_Authority), summarise,
                 SpendLatest = sum(Spend[YEMar == max(YEMar)]),
                 Growth3Yr = CAGR(sum(Spend[YEMar == max(YEMar)]) / 
                                  sum(Spend[YEMar == max(YEMar - 3)]), 4))

map_data <- merge(ta_simpl_gg, rte_sum, by.x="FULLNAME", by.y="Territorial_Authority",
                  all.x=TRUE)

centres <- unique(map_data[ , c("lat.centre", "long.centre", "SpendLatest")])

map_data %>%
   group_by(group) %>%
   ggvis(x = ~long, y = ~ lat) %>%
   layer_paths(fill = ~ Growth3Yr, stroke := "grey70") %>%
   layer_points(x = ~ long.centre, y = ~lat.centre, size = ~ SpendLatest, 
                fill := NA,
                stroke := "black",
                data = centres) %>%
   add_legend("size", 
              title = "Latest tourist spend ($m)",
              properties = legend_props(legend = list(y = 30))) %>%
   add_legend("fill",  
              title= "Three year average growth", 
              properties = legend_props(legend = list(y = 150))) %>%
   set_options(width = 350, height = 400, keep_aspect = TRUE)



