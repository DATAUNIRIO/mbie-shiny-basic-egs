library(shinyapps)
source("prep.R")

setwd("session3")
deployApp("v3", appName = "ivs_demo", account = "mbienz")
