library(mbiedata)
library(mbie)
library(dplyr)
data(RTEs)
head(RTEs)

RTEs_ta <- RTEs %>%
   group_by(RTO, Type, Product) %>%
   summarise(Spend_latest = max(sum(Spend[YEMar == max(YEMar)]), 0),
             Growth = CAGR(sum(Spend[YEMar == max(YEMar)]) / sum(Spend[YEMar == max(YEMar - 1)]), 1)) %>%
   ungroup() %>%
   mutate(Growth = ifelse(abs(Growth) > 30, 30 * sign(Growth), Growth),
          RTO = gsub(" RTO", "", RTO))

summary(RTEs_ta)

tm <- treemap(RTEs_ta, index = c("RTO", "Type", "Product"), 
              vSize = "Spend_latest", vColor = "Growth",
              type = "value", palette = "Spectral",
              fun.aggregate="weighted.mean",
              title.legend = paste0("Growth (%), ", max(RTEs$YEMar) - 1, " to ", max(RTEs$YEMar)))

rtes_treemap <- d3tree2(tm, rootname = "New Zealand")            

save(rtes_treemap, file = "treemap-rtes/rtes_treemap.rda")
