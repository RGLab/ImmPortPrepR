###########################################
###            MAIN FUNCTIONS           ###
###########################################

ImmPortTemplates <- read.csv("data-raw/templates.csv", stringsAsFactors = FALSE)
save(ImmPortTemplates, file = "data/ImmPortTemplates.rda")

ImmPortLookups <- read.csv("data-raw/lkTables.csv", stringsAsFactors = FALSE)
save(ImmPortLookups, file = "data/ImmPortLookups.rda")

# -----   basicStudyDesign DFs not in ImmPortTemplates -------

# study

# inclusion_exclusion

# study_personnel

# planned_visit

# study_2_protocol

# study_file

# study_link

# study_pubmed
