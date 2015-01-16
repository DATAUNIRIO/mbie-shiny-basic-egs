
library(shinyapps)

setAccountInfo(name='peteratmbie', 
                          token='3BE0B1C04F9D288E16F631B7F018925D', 
                          secret='oMkmQlOIgnSlML8S7ZZblp8ntFgoxj9WZACa4Bbo')

deployApp("forecasts_ggvis")
deployApp("simple_map")
