#########################################
###          Helper Functions         ###
#########################################

preCheck_bs <- function(basicStudyDesign){
    if( dim(basicStudyDesign) != c(21,2) ){
        stop("dimensions of basicStudyDesign DF are not c(21,2).")
    }

    nms <- c("Study",
             "User Defined ID",
             "Brief Title",
             "Official Title",
             "Type",
             "Brief Description",
             "Description",
             "HYPOTHESIS",
             "OBJECTIVES",
             "ENDPOINTS",
             "Sponsoring Organization",
             "Target Enrollment",
             "Condition Studied",
             "Minimum Age",
             "Maximum Age",
             "Age Unit",
             "Intervention Agent",
             "Actual Start Date")

    if( basicStudyDesign[ ,1] != nms ){
        stop("The names in the basicStudyDesign DF are not correct.")
    }

    allowedTypes <- c("character",
                      "character",
                      "character",
                      "character",
                      "character",
                      "character",
                      "character",
                      "character",
                      "character",
                      "character",
                      "character",
                      "double",
                      "character",
                      "double",
                      "double",
                      "character",
                      "character",
                      "character")

    bsdTypes <- lapply(basicStudyDesign[,2], typeof)

    if( !(all.equal(bsdTypes, allowedTypes)) ){
        stop("Basic Study Design input types do not match allowed.")
    }

}

preCheck_ac <- function(armOrCohort){

}

preCheck_ie <- function(inclusionExclusion){

}

preCheck_sp <- function(studyPersonnel){

}

preCheck_pv <- function(plannedVisit){

}

preCheck_s2p <- function(study2Protocol){

}


#########################################
###          Main Function            ###
#########################################



transform_basicStudyDesign <- function(basicStudy,
                                       armOrCohort,
                                       inclusionExlusion,
                                       studyPersonnel,
                                       plannedVisit,
                                       study2Protocol,
                                       outputDir = NULL,
                                       validate = TRUE){

    #----PreCheck DFs-------
    preCheck_bs()
    preCheck_ac()
    preCheck_ie()
    preCheck_sp()
    preCheck_pv()
    preCheck_s2p()

    #----Generate tsv output-----



    #-----Validate output------


    return(output)
}
