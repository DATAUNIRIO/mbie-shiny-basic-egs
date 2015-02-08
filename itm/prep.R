


bypurp <- read.csv("itm/raw_data/incountry_by_purpose.csv", skip=1, check.names=FALSE)
names(bypurp)[1] <- "TimePeriod"
bypurp <- melt(bypurp, id.vars="TimePeriod")
bypurp$ValueType <- "Number of visitors in New Zealand by purpose"


bycountry <- read.csv("itm/raw_data/incountry_by_country.csv", skip=1, check.names=FALSE)
names(bycountry)[1] <- "TimePeriod"
bycountry <- melt(bycountry, id.vars="TimePeriod")
bycountry$ValueType <- "Number of visitors in New Zealand by country"


totals <- read.csv("itm/raw_data/arrivals_total.csv", skip=1, check.names=FALSE, na.strings="..")
names(totals)[1] <- "TimePeriod"
totals <- melt(totals, id.vars="TimePeriod")
totals$ValueType <- "Visitor Arrivals Totals"

#--------combine-----------

itm <- rbind(bypurp, bycountry, totals)
itm$variable <- as.character(itm$variable)
itm$ValueType <- as.character(itm$ValueType)

itm$Year <- as.numeric(substring(itm$TimePeriod, 1, 4))
itm$Month <- as.numeric(substring(itm$TimePeriod, 6, 7))
itm$TimePeriod <- with(itm, Year + (Month - 0.5) / 12)
itm$Year <- itm$Month <- NULL

head(itm)
save(itm, file="itm/itm.rda")

