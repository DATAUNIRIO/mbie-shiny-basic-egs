library(mbiedata)
library(mbie)
library(dplyr)
library(extrafont)
library(shinyapps)
data(RTEs)


RTEs_ta <- RTEs %>%
   group_by(RTO, Type, Product) %>%
   summarise(Spend_latest = max(sum(Spend[YEMar == max(YEMar)]), 0),
             Growth = CAGR(sum(Spend[YEMar == max(YEMar)]) / sum(Spend[YEMar == max(YEMar - 1)]), 1)) %>%
   ungroup() %>%
   mutate(Growth = ifelse(abs(Growth) > 30, 30 * sign(Growth), Growth),
          RTO = gsub(" RTO", "", RTO),
          Product_label = paste(Product, FormatDollars(Spend_latest, endmark = "m")))

# sum of spend for Type (international / domestic) within RTO labels
tmp <- RTEs_ta %>%
   group_by(RTO, Type) %>%
   summarise(Spend_latest = sum(Spend_latest)) %>%
   mutate(Type_label = paste(Type, FormatDollars(Spend_latest, endmark = "m"))) %>%
   select(-Spend_latest)

RTEs_ta <- RTEs_ta %>%
   left_join(tmp)


# sum of spend for RTO labels
tmp <- RTEs_ta %>%
   group_by(RTO) %>%
   summarise(Spend_latest = sum(Spend_latest)) %>%
   mutate(RTO_label = paste(RTO, FormatDollars(Spend_latest, endmark = "m"))) %>%
   select(-Spend_latest)

RTEs_ta <- RTEs_ta %>%
   left_join(tmp)


tm <- treemap(RTEs_ta, index = c("RTO_label", "Type_label", "Product_label"), 
              vSize = "Spend_latest", vColor = "Growth",
              type = "value", palette = "Spectral",
              fun.aggregate="weighted.mean",
              title.legend = paste0("Growth (%), ", max(RTEs$YEMar) - 1, " to ", max(RTEs$YEMar)),
              fontfamily.legend = "Verdana", fontsize.legend = 10)
# note - the legend of the d3 version in d3tree2 is a SVG extracted from the tm object above, so we
# can control the fonts here.  The main fonts we control via CSS in the web application itself.

rtes_treemap <- d3tree2(tm, rootname = paste("New Zealand", FormatDollars(sum(RTEs_ta$Spend_latest), "m")))            

save(rtes_treemap, file = "treemap-rtes/rtes_treemap.rda")


