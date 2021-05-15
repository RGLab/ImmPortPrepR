#########################################
###          Main Function            ###
#########################################

#' @title Transform R dataframe into ImmPort csv format for non-Basic Study Design templates
#'
#' @description Based on ImmPort's specifications, the function validates
#' a data frame holding meta or assay data and then outputs a csv
#' for submission to the database.
#'
#' @param df dataframe holding non-header template information
#' @param outputDir filepath to directory for output csv
#' @param validate boolean determining whether to use ImmPort validation scripts on output csv
#' @export
transform_Data <- function(df,
                           outputDir = NULL,
                           validate = TRUE) {
  dataName <- attr(df, "templateName")
  if (!(dataName %in% unique(R2i::ImmPortTemplates$templateName))) {
    stop(paste0(dataName, " is not an option for transformation."))
  }

  #----PreCheck DFs-------
  checkTemplate(df = df)

  #----Generate tsv output-----
  blocks <- list(df)
  names(blocks) <- dataName
  file <- file.path(outputDir, paste0(dataName, ".txt"))

  write_txt(dataName, blocks, file)

  #-----Validate output------

  # return(output)
}
