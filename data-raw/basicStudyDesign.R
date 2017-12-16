# basicStudyDesign_Rownames, assuming that row.names = F when table was created
basicStudyDesign_Rownames <- read.table(file = "data-raw/basicStudyDesign_Rownames.tsv", sep = "\t")
basicStudyDesign_Rownames <- as.vector(basicStudyDesign_Rownames[,1])
save(basicStudyDesign_Rownames, file = "data/basicStudyDesign_Rownames.rda")

# basicStudyDesign_allowedTypes, assuming that row.names = F when table was created
basicStudyDesign_AllowedTypes <- read.table(file = "data-raw/basicStudyDesign_allowedTypes.tsv", sep = "\t")
basicStudyDesign_AllowedTypes <- as.vector(basicStudyDesign_AllowedTypes[,1])
save(basicStudyDesign_AllowedTypes, file = "data/basicStudyDesign_AllowedTypes.rda")

# armOrCohort
armOrCohort <- read.table(file = "data-raw/armOrCohort.tsv", sep = "\t")
save(armOrCohort, file = "data/armOrCohort.rda")

# studyPersonnel 
studyPersonnel <- read.table(file = "data-raw/studyPersonnel.tsv", sep = "\t")
save(studyPersonnel, file = "data/studyPersonnel.rda")

# plannedVisit
plannedVisit <- read.table(file = "data-raw/plannedVisit.tsv", sep = "\t")
save(plannedVisit, file = "data/plannedVisit.rda")

# inclusionExclusion
inclusionExclusion <- read.table(file = "data-raw/inclusionExclusion.tsv", sep = "\t")
save(inclusionExclusion, file = "data/inclusionExclusion.rda")

# study2Protcol
study2Protocol <- read.table(file = "data-raw/study2Protocol.tsv", sep = "\t")
study2Protocol[ is.na(study2Protocol) ] <- ""
save(study2Protocol, file = "data/study2Protocol.rda")

# studyFile
studyFile <- read.table(file = "data-raw/studyFile.tsv", sep = "\t")
save(studyFile, file = "data/studyFile.rda")

# studyLink
studyLink <- read.table(file = "data-raw/studyLink.tsv", sep = "\t")
save(studyLink, file = "data/studyLink.rda")

# studyPubmed
studyPubmed <- read.table(file = "data-raw/studyPubmed.tsv", sep = "\t")
save(studyPubmed, file = "data/studyPubmed.rda")

