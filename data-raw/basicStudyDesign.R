# bsdRownames, assuming that row.names = F when table was created
bsdRownames <- read.table(file = "data-raw/basicStudyDesign_Rownames.tsv", sep = "\t")
bsdRownames <- as.vector(bsdRownames[,1])
save(bsdRownames, file = "data/bsdRownames.rda")

# bsdAllowedTypes, assuming that row.names = F when table was created
bsdAllowedTypes <- read.table(file = "data-raw/basicStudyDesign_AllowedTypes.tsv", sep = "\t")
bsdAllowedTypes <- as.vector(bsdAllowedTypes[,1])
save(bsdAllowedTypes, file = "data/bsdAllowedTypes.rda")

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

