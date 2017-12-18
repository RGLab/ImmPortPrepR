# bsdRownames, assuming that row.names = F when table was created
bsdRownames <- read.table(file = "data-raw/basicStudyDesign_Rownames.tsv", sep = "\t")
bsdRownames <- as.vector(bsdRownames[,1])
save(bsdRownames, file = "data/bsdRownames.rda")

# bsdAllowedTypes, assuming that row.names = F when table was created
bsdAllowedTypes <- read.table(file = "data-raw/basicStudyDesign_AllowedTypes.tsv", sep = "\t")
bsdAllowedTypes <- as.vector(bsdAllowedTypes[,1])
save(bsdAllowedTypes, file = "data/bsdAllowedTypes.rda")

# armOrCohort
aoc_header <- read.table(file = "data-raw/armOrCohort.tsv", sep = "\t")
save(aoc_header, file = "data/aoc_header.rda")

# studyPersonnel
spe_header <- read.table(file = "data-raw/studyPersonnel.tsv", sep = "\t")
save(spe_header, file = "data/spe_header.rda")

# plannedVisit
pv_header <- read.table(file = "data-raw/plannedVisit.tsv", sep = "\t")
save(pv_header, file = "data/pv_header.rda")

# inclusionExclusion
ie_header <- read.table(file = "data-raw/inclusionExclusion.tsv", sep = "\t")
save(ie_header, file = "data/ie_header.rda")

# study2Protcol
s2p_header <- read.table(file = "data-raw/study2Protocol.tsv", sep = "\t")
s2p_header[ is.na(s2p_header) ] <- ""
save(s2p_header, file = "data/s2p_header.rda")

# studyFile
sf_header <- read.table(file = "data-raw/studyFile.tsv", sep = "\t")
save(sf_header, file = "data/sf_header.rda")

# studyLink
sl_header <- read.table(file = "data-raw/studyLink.tsv", sep = "\t")
save(sl_header, file = "data/sl_header.rda")

# studyPubmed
spu_header <- read.table(file = "data-raw/studyPubmed.tsv", sep = "\t")
save(spu_header , file = "data/spu_header .rda")

