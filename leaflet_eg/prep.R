visited_m_all$PopUp <- paste(visited_m_all$WhereStayed, 
                             visited_m_all$Nights %>% 
                                round(-1) %>% 
                                format(big.mark = ",") %>% 
                                paste("nights"), sep="<BR>")                     

save(visited_m_all, file="leaflet_eg/visits_by_yr_by_country.rda")
