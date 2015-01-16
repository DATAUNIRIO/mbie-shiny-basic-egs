# We want as much prep done prior to the app being loaded up as possible

# Version aggregated for all countries of origin
visited_m_agg <-  visited_m_all %>%
   filter(Country != "All countries") %>%
   group_by(WhereStayed, Year, Latitude, Longitude) %>%
   summarise(Nights = sum(Nights, na.rm=TRUE))

visited_m_agg$Country <- "All countries"

visited_m_combined <- rbind(visited_m_all, visited_m_agg)

visited_m_combined$PopUp <- paste0("<pop>", with(visited_m_combined, 
                                                    paste(WhereStayed, 
                                                     Nights %>% 
                                                        round(-1) %>% 
                                                        format(big.mark = ",") %>% 
                                                        paste("nights"), sep="<BR>")),
                           "</pop>")

# A version averaged 2009 to 2013
visited_m_av <-  visited_m_combined %>%
   filter(Year > 2008 & Year < 2014) %>%
   group_by(WhereStayed, Country, Latitude, Longitude) %>%
   summarise(Nights = mean(Nights, na.rm=TRUE))

visited_m_av$PopUp <- paste0("<pop>", with(visited_m_av, paste(WhereStayed, 
                                                 Nights %>% 
                                                    round(-1) %>% 
                                                    format(big.mark = ",") %>% 
                                                    paste("nights"), sep="<BR>") ),
                            "</pop>")


save(visited_m_combined, visited_m_av, file="leaflet_eg/visited_m_combined.rda")

countries <- as.character(unique(visited_m_combined$Country))
countries <- countries[countries != "Other"]
countries <- countries[order(countries)]
countries <- countries[c(2, 1, 3:length(countries))] # swap around All and Africa

years <- as.numeric(unique(visited_m_all$Year))
years <- years[!is.na(years)]
years <- years[order(-years)]

save(countries, years, file="leaflet_eg/countries_and_years.rda")
