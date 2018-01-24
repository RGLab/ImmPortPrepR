#########################################
###          Main Function            ###
#########################################

#' @title Transform R dataframes into ImmPort basicStudyDesign.csv format
#'
#' @description Based on ImmPort's specifications, the function validates
#' a group of dataframes holding metaData and then outputs a csv
#' for submission to the database.
#'
#' @param blocks a named list of the 9 data frames that comprise basic study design template
#' @param outputDir filepath to directory for output csv
#' @param validate boolean determining whether to use ImmPort validation scripts on output csv
#' @export
transform_basicStudyDesign <- function(blocks,
                                       outputDir = NULL,
                                       validate = TRUE){

    # Any errors in checkObj will stop transformation.
    mapply(checkTemplate,
           df = blocks)

    # ----- Convert to Vector / Lists -------
    # Convert to vector if empty DF so that no
    # extra rows are written in output file.
    # Must be done after checks because checks
    # assume data.frame input.
    blocks <- lapply(blocks, function(x){
        chk <- unique(unname(unlist(x[1,])))
        if( all(chk == "" | is.na(chk)) ){
            return(colnames(x))
        }else{
            return(x)
        }
    })

    # Convert 'study' and 'protocol' to lists
    # to preserve data types and prepare for
    # write out.
    if( is.data.frame(blocks$study) ){
        blocks$study <- as.list(blocks$study)
    }

    if( is.data.frame(blocks$protocol) ){
        blocks$protocol <- as.list(blocks$protocol)
    }

    # --------- Generate tsv output -------------
    name <- "basic_study_design"
    if(is.null(outputDir)){ outputDir <- getwd() }
    file <- file.path(outputDir, paste0(name, ".txt"))

    write_txt(name = name,
              blocks = blocks,
              file = file)

    # ---------- Validate output -----------------
    # TODO: waiting on patrick for scripts

}
