###########################################
###            MAIN FUNCTIONS           ###
###########################################

ImmPortTemplates <- read.csv("data-raw/templates.csv", stringsAsFactors = FALSE)
save(ImmPortTemplates, file = "data/ImmPortTemplates.rda")

ImmPortLookups <- read.csv("data-raw/lkTables.csv", stringsAsFactors = FALSE)
save(ImmPortLookups, file = "data/ImmPortLookups.rda")
