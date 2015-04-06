library(RODBC)
library(dplyr)
library(mbie)
library(tidyr)
TRED <- odbcConnect("TRED_Prod", uid="analyst")


SQL <- "
SELECT 
  Year                                            AS Year, 
  Qtr                                             AS Qtr,
  vw_ClassificationLevels.L1Description           AS CountryGrouped,  
  sum(PopulationWeight)                           AS Departures,
  sum(PopulationWeight * lengthofstay)              AS VisitorNights,
  sum(PopulationWeight * WeightedSpend / 1000000) AS Spend,
  sum(PopulationWeight * WeightedSpend) / 
      sum(PopulationWeight)                       AS SpendPerTrip,
  sum(PopulationWeight * WeightedSpend) / 
      sum(PopulationWeight * lengthofstay)          AS SpendPerNight

  FROM Production.vw_IVSSurveyMainHeader

  LEFT OUTER JOIN Classifications.vw_ClassificationLevels 
    ON vw_ClassificationLevels.L2Description = CORNextYr 
    AND L1ClassificationName = 'MBIEPub_CountryIVS_1_Geography' 
    AND L2ClassificationName = 'MBIEPub_Country_99_Geography'                           

  GROUP BY Year, Qtr, vw_ClassificationLevels.L1Description
  "

ivs <- sqlQuery(TRED, SQL) %>%
   mutate(Qtr = as.numeric(substring(Qtr, 6, 6)),
          Period = Year + (Qtr - 0.5)  / 4) 

# define a function for renaming variables to be sure we do it the same both times:
rename.ivs <- function(Variable){
   rename.levels(Variable, 
                 orig = c("SpendPerTrip", "Spend", "Departures", "VisitorNights", "SpendPerNight"), 
                 new = c("Spend Per Trip", "Spend ($m)", "Visitor numbers aged 15+",
                         "Visitor Nights aged 15+", "Spend per night"))
   }

# time series version
ivs1 <-
   ivs %>%
   gather("Variable", "Value", Departures:SpendPerNight) %>%
   mutate(Variable = rename.ivs(Variable))

# dot plot version
ivs2 <- 
   ivs %>%
   filter(Period > max(Period - 1)) %>%
   group_by(CountryGrouped) %>%
   summarise(
      Departures = sum(Departures),
      VisitorNights = sum(VisitorNights),
      Spend = sum(Spend * Departures) / sum(Departures),
      SpendPerTrip = sum(Spend * 1000000) / sum(Departures),
      SpendPerNight = sum(Spend * 1000000) / sum(VisitorNights)
   ) %>%
   gather("Variable", "Value", Departures:SpendPerNight) %>%
   mutate(Variable = rename.ivs(Variable))


# exact location depends on training lab environment

AllCountries <- ivs2$CountryGrouped %>% unique() %>% as.character()
AllVariables <- ivs2$Variable %>% unique() %>% as.character()


save(ivs1, ivs2, file = "v1/ivs.rda")
save(ivs1, ivs2, file = "v2/ivs.rda")
save(ivs1, ivs2, file = "v3/ivs.rda")
save(AllCountries, AllVariables, file = "v1/dimensions.rda")
save(AllCountries, AllVariables, file = "v2/dimensions.rda")
save(AllCountries, AllVariables, file = "v3/dimensions.rda")
