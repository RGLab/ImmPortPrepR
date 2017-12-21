#########################################
###          Main Function            ###
#########################################

#' @export
transform_basicStudyDesign <- function(study,
                                       arm_or_cohort,
                                       inclusion_exclusion,
                                       study_personnel,
                                       planned_visit,
                                       study_2_protocol,
                                       study_file,
                                       study_link,
                                       study_pubmed,
                                       outputDir = NULL,
                                       validate = TRUE){

    #----PreCheck DFs-------
    load("data/ImmPortTemplates.rda")
    load("data/ImmPortLookups.rda")

    # get arg list and clean
    argList <- as.list(match.call())
    argList <- argList[ -1 ]
    argList <- argList[ !(names(argList) %in% c("outputDir", "validate")) ]
    
    # Check arg list
    if( length(argList) != 9 ){
      stop("Number of argument DFs is not 9. Please ensure all arguments are passed.")
    }

    # lapply checkObj
    lapply(argList,
           checkObj,
           ImmPortTemplateName = names(argList),
           templatesDF = ImmPortTemplates,
           lookupsDF = ImmPortLookups)

    #----Generate tsv output-----
    name <- "basic_study_design"
    blocks <- list("study" = study,
                   "arm_or_cohort" = arm_or_cohort,
                   "study_personnel" = study_personnel,
                   "planned_visit" = planned_visit,
                   "inclusion_exclusion" = inclusion_exclusion,
                   "study_2_protocol" = study_2_protocol,
                   "study_file" = study_file,
                   "study_link" = study_link,
                   "study_pubmed" = study_pubmed)
    file <- file.path(outputDir, paste0(name, ".txt"))

    write_txt(name, blocks, file)

    #-----Validate output------

    return(output)
}
