library(shinyapps)
source("prep.R")

setwd("session3")


# deployApp("v3", appName = "ivs_demo", account = "mbienz")


# This training folder includes 3 versions of the same IVS shiny app.  
# v1 contains just the preparation script (which downloads and reshpaes data) and the minimum interactivity
#    and plots
# v2 demonstrates customisation of the plots
# v3 adds interactivity in three different ways - mouse hover, and mouseclick via ggvis; and javascript in
#    combination with moving data between server.r and ui.r that wasn't created with an R function

# By the end of this session you should have familiarity and examples of:
#  * ggvis plot polishing inlcuding formats of axis labels; legends; controlling width and height; and a few
#    other things
#  * add a data-driven tooltip to a ggvis plot
#  * have an event-driven update of some of the input list by clicking on a ggvis plot
#  * at least be able to get started for incorporating javascript into shiny apps.