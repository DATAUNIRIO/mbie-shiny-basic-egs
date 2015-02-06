
# library(mbiedata)
# library(mbiemaps)
data(RTEs)
str(RTEs)
dim(RTEs)

RTEs <- RTEs[ , c("YEMar", "Territorial_Authority", "Product", "Spend")] %>%
    group_by(Territorial_Authority, Product, YEMar) %>%
    summarise(Spend = sum(Spend)) 

class(RTEs) <- "data.frame"



RTEs$TA <- gsub(" District", "", RTEs$Territorial_Authority)
RTEs$TA <- gsub(" City", "", RTEs$TA)

save(RTEs, file="simple_map/RTEs.rda")

