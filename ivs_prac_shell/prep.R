library(RODBC)
library(dplyr)
library(mbie)
TRED <- odbcConnect("TRED_Prod")

ivs <- sqlQuery(TRED, 
                 "select Qtr, CORNextYr, sum(PopulationWeight * WeightedSpend / 1000000) as spend
                 from production.vw_IVSSurveyMainHeader
                 group by Qtr, CORNextYr") %>%
   mutate(Country = CountryGroup(CORNextYr),
          Q = substring(Qtr, 6, 6) %>% as.numeric(),
          Y = substring(Qtr, 1, 4) %>% as.numeric(),
          TimePeriod = Y + (Q - 0.5) / 4) %>%
   group_by(Country, Q, Y, TimePeriod) %>%
   summarise(spend = sum(spend)) %>%
   data.frame()

# exact location depends on training lab environment
save(ivs, file = "ivs_prac1/dev/ivs.rda")
