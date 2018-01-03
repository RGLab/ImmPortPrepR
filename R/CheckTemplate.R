###########################################
###          Helper Functions           ###
###########################################

checkClass <- function(df, dfName) {
  if(class(df)[1] != "data.frame") {
    stop(paste0(dfName, " data must be input as a data frame. Please re-format."))
  }
}

checkDim <- function(df, templateInfo, ImmPortTemplateName){
    res <- ncol(df) == nrow(templateInfo)

    if( res == FALSE ){
        stop(paste0("Number of columns in ", ImmPortTemplateName, " is not correct."))
    }
}

checkColnames <- function(df, ImmPortTemplateName, templateInfo){
    res <- all(colnames(df) == templateInfo$templateColumn)

    if( res == FALSE ){
        stop(paste0("Colnames of ", ImmPortTemplateName, " are not correct."))
    }
}

checkTypes <- function(df, templateInfo, ImmPortTemplateName){

    templateInfo$jsonDataType <- updateTypes(templateInfo$jsonDataType)

    res <- sapply(seq(ncol(df)), FUN = function(x){
        all(typeof(df[[x]]) == templateInfo$jsonDataType[[x]])
    })
    badCols <- colnames(df)[res == FALSE]

    if( any(res == FALSE) ){
       message("Type errors found in following columns: ")
       message(paste(badCols, collapse = "\n"))
       stop("Check data types for ", ImmPortTemplateName)
    }
}

checkRequired <- function(df, templateInfo, ImmPortTemplateName){
    req <- templateInfo$templateColumn[ templateInfo$required == TRUE]
    res <- sapply(req, FUN = function(x){
        any(is.na(df[[x]]) | df[[x]] == "")
    })
    if( any(res == TRUE) ){
        message("Required columns with NA or blank values: ")
        message(paste(res[res == TRUE], collapse = "\n"))
        stop("Check data for ", ImmPortTemplateName)
    }
}

# Helper for getting vector of lookup values
getLkVals <- function(lkTblNm, templateInfo, lookupsDF, cv){
    colNm <- ifelse(cv == TRUE, "cvTableName", "pvTableName")
    lkTbl <- templateInfo[[colNm]][ templateInfo$templateColumn == x ]
    lkVals <- lookupsDF$name[ lookupsDF$lookup == lkTbl ]
    if( any(grepl(";", lkVals)) ){
        lkVals <- unname(unlist(sapply(lkVals, function(y){ strsplit(y, ";") })))
    }
}

# Helper for comparing inputVals to lkVals
compareVals <- function(compCols, templateInfo, lookupsDF, cv = FALSE){
    res <- sapply(compCols, function(x){
        lkVals <- getLkVals(x, templateInfo, lookupsDF, cv)
        all(df[[x]] %in% lkVals)
    })
    if( any(res == FALSE) ){
        message("Columns with lookups having non-preferred or controlled values: ")
        message(paste(res[res == TRUE], collapse = "\n"))
    }
    return(res)
}

checkFormat <- function(df, templateInfo, lookupsDF, ImmPortTemplateName){
    resPv <- resCv <- NULL

    pvCols <- templateInfo$templateColumn[ !is.na(templateInfo$pvTableName) ]
    if( length(pvCols) > 0){
        resPv <- compareVals(pvCols, templateInfo, lookupsDF, cv = FALSE)
    }
    cvCols <- templateInfo$templateColumn[ !is.na(templateInfo$cvTableName) ]
    if( length(pvCols) > 0){
        resCv <- compareVals(cvCols, templateInfo, lookupsDF, cv = TRUE)
    }

    res <- c(resPv, resCv)

    if( !is.null(res) && any(res == FALSE) ){
        stop(paste0(ImmPortTemplateName, " has non-controlled terms."))
    }
}

###########################################
###          Main Function              ###
###########################################

#' @title Check template data frame
#'
#' @description Check template data frame based on class, dimensions, colnames,
#'     data types, and format.
#'
#' @param df data frame with user entered data
#' @param ImmPortTemplateName Name of ImmPort Template to compare against
#' @export
checkTemplate <- function(df, ImmPortTemplateName){

    templateInfo <- getSingleTemplate(ImmPortTemplateName)

    # template checks
    checkClass(df, ImmPortTemplateName)
    checkDim(df, templateInfo, ImmPortTemplateName)
    checkColnames(df, ImmPortTemplateName, templateInfo)
    checkTypes(df, templateInfo, ImmPortTemplateName)

    # Allow empty tables for certain non-required sub-tables in BSD
    if( ImmPortTemplateName %in% c("study_file","study_link","study_pubmed")){
        tmp <- unique(unname(unlist(df[1,])))
        if( all(tmp == "" | is.na(tmp)) ){
            message(paste0("skipping empty ", ImmPortTemplateName, " table"))
            return()
        }
    }

    checkRequired(df, templateInfo, ImmPortTemplateName)

    # format check using lookups
    pv <- templateInfo$pvTableName[ !is.na(templateInfo$pvTableName) ]
    cv <- templateInfo$cvTableName[ !is.na(templateInfo$cvTableName) ]
    allLookups <- c(pv,cv)
    if( length(allLookups) > 0 ){
        lookupsDF <- ImmPortLookups[ ImmPortLookups$lookup %in% allLookups, ]
        checkFormat(df, templateInfo, lookupsDF, ImmPortTemplateName)
    }
}
