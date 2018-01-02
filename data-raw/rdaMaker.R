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


