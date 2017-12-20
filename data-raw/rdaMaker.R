###########################################
###            Meta-Data                ###
###########################################

# BasicStudyDesign
bsdChk <- read.csv("data-raw/basicStudyDesign.csv", stringsAsFactors = FALSE)
save(bsdChk, file = "data/bsdChk.rda")

# Protocols
protocolsChk <- read.csv("data-raw/protocols.csv", stringsAsFactors = FALSE)
save(protocolsChk, file = "data/protocolsChk.rda")

# Treatments
treatmentsChk <- read.csv("data-raw/treatments.csv", stringsAsFactors = FALSE)
save(treatmentsChk, file = "data/treatmentsChk.rda")

# SubjectsHuman
subjectsHumanChk <- read.csv("data-raw/subjectsHuman.csv", stringsAsFactors = FALSE)
save(subjectsHumanChk, file = "data/subjectsHumanChk.rda")

# SubjectsAnimal
subjectsAnimalChk <- read.csv("data-raw/subjectsAnimal.csv", stringsAsFactors = FALSE)
save(subjectsAnimalChk, file = "data/subjectsAnimalChk.rda")

# adverseEvents

# assessments


###########################################
###            Assay-Data               ###
###########################################

# controlSamples

# CyTOF_derived_data, has commas in controlled terms so tab-delim
CyTOF_Derived_data <- read.table("data-raw/CyTOF_Derived_data.txt",
                                 header = TRUE,
                                 sep = "\t",
                                 stringsAsFactors = FALSE)
save(CyTOF_Derived_data, file = "data/CyTOF_Derived_data")
