###########################################
###          HELPER FUNCTIONS           ###
###########################################

# Create DF from ImmPort templates or lkTables json files
#' @importFrom utils write.csv
#' @importFrom jsonlite fromJSON
#' @importFrom plyr ldply
.json2DF <- function(jsonFile, writeCSV = FALSE){
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
        bsdSubTbls <- c("study",
                        "study_categorization",
                        "study_2_condition_or_disease",
                        "arm_or_cohort",
                        "study_personnel",
                        "planned_visit",
                        "inclusion_exclusion",
                        "study_2_protocol",
                        "study_file",
                        "study_link",
                        "study_pubmed")
        bsd <- bsd[ bsd$name %in% bsdSubTbls,]
        for( templateName in bsdSubTbls ){
            loc <- grep( paste0("^", templateName, "$"), bsd$name)
            if( length(loc) > 1 ){
                badLoc <- loc[2:length(loc)]
                bsd <- bsd[-badLoc,]
            }
        }
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

#' @importFrom Rlabkey labkey.selectRows
.makeContextVector <- function(tableName, colName){
    print(paste0(tableName, "-", colName))
    tmp <- labkey.selectRows(baseUrl = "https://www.immunespace.org",
                             folderPath = "/Studies/",
                             schemaName = "ImmPort",
                             queryName = tableName,
                             colSelect = c(colName),
                             colNameOpt = "fieldname")
    words <- vec2Words(tmp)
    words <- words[ !(words %in% stopwords(source = "smart")) ]
}
