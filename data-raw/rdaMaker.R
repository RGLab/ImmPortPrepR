###########################################
###            MAIN FUNCTIONS           ###
###########################################

# Generate template info and lookup objects
dmpTbl <- R2i:::.json2DF("data-raw/lkTables.json", writeCSV = TRUE)
dmpTpls <- R2i:::.json2DF("data-raw/templates.json", writeCSV = TRUE)

ImmPortTemplates <- read.csv("data-raw/templates.csv", stringsAsFactors = FALSE)
save(ImmPortTemplates, file = "data/ImmPortTemplates.rda")

ImmPortLookups <- read.csv("data-raw/lkTables.csv", stringsAsFactors = FALSE)
save(ImmPortLookups, file = "data/ImmPortLookups.rda")

# Create demo data set for basic study design
source("data-raw/demoData.R")
save(demoData, file = "data/demoData.rda")

# Create word frequencies list object
ISqueries <- read.csv("data-raw/ImmuneSpaceQueries.csv", stringsAsFactors = F)
lsWords <- mapply(R2i:::.makeContextVector,
  tableName = ISqueries$tableName,
  colName = ISqueries$columnName
)
names(lsWords) <- paste0(ISqueries$tableName, "-", ISqueries$columnName)
ISFreqsByNm <- sapply(lsWords, table)
save(ISFreqsByNm, file = "data/ISFreqsByNm.rda")
ISFreqsAll <- table(unlist(lsWords))
save(ISFreqsAll, file = "data/ISFreqsAll.rda")
