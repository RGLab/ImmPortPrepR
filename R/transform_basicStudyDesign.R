#########################################
###          Main Function            ###
#########################################

#' @title Transform R dataframes into ImmPort basicStudyDesign.csv format
#'
#' @description Based on ImmPort's specifications, the function validates
#' a group of dataframes holding metaData and then outputs a csv
#' for submission to the database.
#'
#' @param study a two-column dataframe with names and values for study metaData
#' @param arm_or_cohort four column df defining arms or cohorts in study
#' @param inclusion_exclusion three column df defining allowed participant criteria
#' @param study_personnel ten column df identifying all study personnel
#' @param planned_visit seven column df describing all visits and potential variation
#' @param study_2_protocol small 1 x 2 df with protocol reference
#' @param study_file three column df describing all related files being submitted
#' @param study_link two column df with web links for study
#' @param study_pubmed nine column df identifying publication information
#' @param outputDir filepath to directory for output csv
#' @param validate boolean determining whether to use ImmPort validation scripts on output csv
#' @export
transform_basicStudyDesign <- function(study,
                                       arm_or_cohort,
                                       study_personnel,
                                       planned_visit,
                                       inclusion_exclusion,
                                       study_2_protocol,
                                       study_file,
                                       study_link,
                                       study_pubmed,
                                       outputDir = NULL,
                                       validate = TRUE){

    #----PreCheck DFs-------
    blocks <- list("study" = study,
                    "arm_or_cohort" = arm_or_cohort,
                    "study_personnel" = study_personnel,
                    "planned_visit" = planned_visit,
                    "inclusion_exclusion" = inclusion_exclusion,
                    "study_2_protocol" = study_2_protocol,
                    "study_file" = study_file,
                    "study_link" = study_link,
                    "study_pubmed" = study_pubmed)

    # any errors in checkObj will stop transformation
    mapply(checkObj,
           df = blocks,
           ImmPortTemplateName = names(blocks))

    #----Generate tsv output-----
    name <- "basic_study_design"
    if(is.null(outputDir)){ outputDir <- getwd() }
    file <- file.path(outputDir, paste0(name, ".txt"))

    write_txt(name = name,
              blocks = blocks,
              file = file)

    #-----Validate output------

}
