visited_m_all$PopUp <- paste(visited_m_all$WhereStayed, 
                             visited_m_all$Nights %>% 
                                round(-1) %>% 
                                format(big.mark = ",") %>% 
                                paste("nights"), sep="<BR>")                     

save(visited_m_all, file="leaflet_eg/visits_by_yr_by_country.rda")

countries <- as.character(unique(visited_m_all$Country))
countries <- countries[countries != "Other"]
countries <- countries[order(countries)]

years <- as.numeric(unique(visited_m_all$Year))
years <- years[!is.na(years)]
years <- years[order(-years)]



save(countries, years, file="leaflet_eg/countries_and_years.rda")
