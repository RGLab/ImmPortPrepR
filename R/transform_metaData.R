#########################################
###          Main Function            ###
#########################################

transform_metaData <- function(dataName,
                               outputDir = NULL,
                               validate = TRUE){

    mDataOptions <- c("protocols",
                      "treatments",
                      "subjectsHuman")

    if( !(dataName %in% mDataOptions) ){
        stop(paste0(dataName, " is not an option for transformation."))
    }

    #----PreCheck DFs-------
    chkVals <- paste0(dataName, "Chk")
    load(paste0("data/", chkVals, ".rda"))
    df <- get(dataName, envir = globalenv())

    checkObj(df, chkVals, dataName)

    #----Generate tsv output-----
    blocks <- list(df)
    names(blocks) <- dataName
    file <- file.path(outputDir, paste0(dataName, ".txt"))

    write_txt(dataName, blocks, file)

    #-----Validate output------

    return(output)
}


