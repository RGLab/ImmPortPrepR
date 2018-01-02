#########################################
###          Main Function            ###
#########################################

#' @title Transform R dataframe into ImmPort csv format for non-Basic Study Design templates
#'
#' @description Based on ImmPort's specifications, the function validates
#' a data frame holding meta or assay data and then outputs a csv
#' for submission to the database.
#'
#' @param dataName name of the data frame object to retrieve from the global environment
#' @param outputDir filepath to directory for output csv
#' @param validate boolean determining whether to use ImmPort validation scripts on output csv
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


