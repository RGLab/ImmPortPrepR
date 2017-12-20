#########################################
###          Helper Functions         ###
#########################################

#' @importFrom utils packageVersion
get_version <- function() {
  ver <- packageVersion("Import2ImmPort")

  paste(ver[[1, 1]], ver[[1, 2]], sep = ".")
}

# Create DF from ImmPort templates or lkTables json files
json2DF <- function(jsonFile, writeCSV = FALSE){
    tmp <- jsonlite::fromJSON(txt = jsonFile)

    # templates
    if( grepl("templates.json", jsonFile) ){
        dfLs <- tmp$columns
        fileNm <- "data-raw/templates.csv"

    # lookups
    }else{
        dfLs <- lapply(seq(1:length(tmp$name)), FUN = function(x){
            df <- tmp$rows[[x]]
            df$lookup <- tmp$name[[x]]
            df <- df[ df$description != "", ] # some tbls had header name
        })
        fileNm <- "data-raw/lkTables.csv"
    }

    df <- plyr::ldply(dfLs, data.frame)
    if( writeCSV == TRUE ){ write.csv(df, file = fileNm, row.names = FALSE) }

    return(df)
}
