###########################################
###          HELPER FUNCTIONS           ###
###########################################

# Create DF from ImmPort templates or lkTables json files
json2DF <- function(jsonFile, writeCSV = FALSE){
    tmp <- jsonlite::fromJSON(txt = jsonFile)

    # templates + basicStudyDesign
    if( grepl("templates.json", jsonFile) ){

        # DFs in tmp$columns do not have a way of identifying the
        # actual template from any of the standalone columns, therefore
        # must add a column that has the names from another element
        # to make this feasible.
        names(tmp$columns) <- gsub(".txt", "", tmp$fileName)
        tmpLs <- lapply(seq(length(tmp$columns)), function(x){
            tmp$columns[[x]]$templateName <- names(tmp$columns)[[x]]
            return(tmp$columns[[x]])
        })
        df <- plyr::ldply(tmpLs, data.frame)

        # The basicStudyDesign template is found unparsed in another
        # element within the json output and must be constructed.
        bsd <- plyr::ldply(tmp$templates, data.frame)
        bsd <- bsd[1:9,] # duplicate tables created otherwise
        bsd <- plyr::ldply(lapply(bsd$columns, data.frame), rbind)
        bsd$templateName <- bsd$tableName

        df <- rbind(df, bsd)
        fileNm <- "data-raw/templates.csv"

    # lookups
    }else{
        dfLs <- lapply(seq(1:length(tmp$name)), FUN = function(x){
            df <- tmp$rows[[x]]
            df$lookup <- tmp$name[[x]]
            df <- df[ df$description != "", ] # some tbls had header name
        })
        fileNm <- "data-raw/lkTables.csv"
        df <- plyr::ldply(dfLs, data.frame)
    }

    if( writeCSV == TRUE ){ write.csv(df, file = fileNm, row.names = FALSE) }

    return(df)
}

# build this using the ImmuneSpaceR in the /SDYXXX/ImmPort path
# pull meta-data for IS studies (basicStudyDesign, bioSamples$description?)
# 1. study
# brief_description, brief_condition, condition_studies, description, hypothesis, official_title, sponsoring_organization, intervention_agent
# 2. arm_or_cohort
# 3. inclusion_exclusion
# 4. planned_visit
# 5. study_2_protocol
# 6. study_file
# 7. study_link
# 8. study_personnel
# 9. study_pubmed
# biosamples$description
# for each study ...
# create vector for each tbl-col - rda obj = list of lists
# do frequency counts
# create master list that combines all words - rda obj
# combine all studies
#

#' @import Rlabkey
makeContextVector <- function(tableName, colName){
    tmp <- labkey.selectRows(baseUrl = "https://www.immunespace.org",
                      folderPath = "/Studies/",
                      schemaName = "ImmPort",
                      queryName = tableName,
                      colSelect = c(colName))
    tmp <- tmp[ !is.na(tmp) ] # rm NAs
    tmp <- gsub("\\d+|[[:punct:]]","",tmp) # rm digits
    tmp <- gsub("\\s{2,4}", " ", tmp) # rm extra spaces
    tmp <- tolower(unique(tmp)) # want to have frequency within different contexts
    words <- table(unlist(strsplit(tmp, " "))) # generate frequency count table

}


###########################################
###            MAIN FUNCTIONS           ###
###########################################

dmpTbl <- json2DF("data-raw/lkTables.json", writeCSV = TRUE)
dmpTpls <- json2DF("data-raw/templates.json", writeCSV = TRUE)

ImmPortTemplates <- read.csv("data-raw/templates.csv", stringsAsFactors = FALSE)
save(ImmPortTemplates, file = "data/ImmPortTemplates.rda")

ImmPortLookups <- read.csv("data-raw/lkTables.csv", stringsAsFactors = FALSE)
save(ImmPortLookups, file = "data/ImmPortLookups.rda")

source("data-raw/demoData.R")
save(demoData, file = "data/demoData.rda")

