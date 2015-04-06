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
  sum(PopulationWeight * WeightedSpend / 1000000) AS Spend,
  sum(PopulationWeight * WeightedSpend) / 
      sum(PopulationWeight)                       AS SpendPerTrip

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

# time series version
ivs1 <-
   ivs %>%
   gather("Variable", "Value", Departures:SpendPerTrip) %>%
   mutate(Variable = rename.levels(Variable, 
                                   orig = c("SpendPerTrip", "Spend", "Departures"), 
                                   new = c("Spend Per Trip", "Spend ($m)", "Visitor numbers aged 15+")))

# dot plot version
ivs2 <- 
   ivs %>%
   filter(Period > max(Period - 1)) %>%
   group_by(CountryGrouped) %>%
   summarise(
      Departures = sum(Departures),
      Spend = sum(Spend * Departures) / sum(Departures),
      SpendPerTrip = Spend * 1000000 / Departures
   ) %>%
   gather("Variable", "Value", Departures:SpendPerTrip) %>%
   mutate(Variable = rename.levels(Variable, 
                                   orig = c("SpendPerTrip", "Spend", "Departures"), 
                                   new = c("Spend Per Trip", "Spend ($m)", "Visitor numbers aged 15+")))


# exact location depends on training lab environment

AllCountries <- ivs2$CountryGrouped %>% unique() %>% as.character()
AllVariables <- ivs2$Variable %>% unique() %>% as.character()


save(ivs1, ivs2, file = "session3/shiny_shell/ivs.rda")
save(ivs1, ivs2, file = "session3/shiny_final/ivs.rda")
save(AllCountries, AllVariables, file = "session3/shiny_shell/dimensions.rda")
save(AllCountries, AllVariables, file = "session3/shiny_final/dimensions.rda")
