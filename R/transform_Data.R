#########################################
###          Main Function            ###
#########################################

#' @export
transform_Data <- function(dataName,
                           outputDir = NULL,
                           validate = TRUE){

    if( !(dataName %in% unique(ImmPortTemplates$tableName)) ){
        stop(paste0(dataName, " is not an option for transformation."))
    }

    #----PreCheck DFs-------
    df <- get(dataName, envir = globalenv())
    checkObj(df = df,
             ImmPortTemplateName = dataName,
             templatesDF = ImmPortTemplates,
             lookupsDF = ImmPortLookups
             )

    #----Generate tsv output-----
    blocks <- list(df)
    names(blocks) <- dataName
    file <- file.path(outputDir, paste0(dataName, ".txt"))

    write_txt(dataName, blocks, file)

    #-----Validate output------

    return(output)
}


