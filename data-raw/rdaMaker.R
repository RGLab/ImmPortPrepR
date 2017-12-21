###########################################
###            MAIN FUNCTIONS           ###
###########################################

ImmPortTemplates <- read.csv("data-raw/templates.csv", stringsAsFactors = FALSE)
save(ImmPortTemplates, file = "data/ImmPortTemplates.rda")

ImmPortLookups <- read.csv("data-raw/lkTables.csv", stringsAsFactors = FALSE)
save(ImmPortLookups, file = "data/ImmPortLookups.rda")

# basicStudyDesign DFs not in ImmPortTemplates
basicStudyDesignTemplates <- read.csv("data-raw/basicStudyDesign.csv", stringsAsFactors = FALSE)
save(basicStudyDesignTemplates, file = "data/basicStudyDesignTemplates.rda")
