###########################################
###    Pre-Transform Check Functions    ###
###########################################

checkClass <- function(df, dfName) {
  if(class(df)[1] != "data.frame") {
    stop(paste0(dfName, " data must be input as a data frame. Please re-format."))
  }
}

checkDim <- function(df, templateDF, ImmPortTemplateName){
    if( ImmPortTemplateName %in% c("study", "study_2_protocol") ){
      res <- nrow(df) == nrow(templateDF)
    }else{
      res <- ncol(df) == nrow(templateDF)
    }

    if( res == FALSE ){
        stop(paste0("Number of columns in ", ImmPortTemplateName, " is not correct."))
    }
}

checkColnames <- function(df, ImmPortTemplateName, templateDF, varCol){
    if( ImmPortTemplateName %in% c("study", "study_2_protocol") ){
      res <- all(df[,1] == templateDF[[varCol]])
    }else{
      res <- all(colnames(df) == templateDF[[varCol]])
    }

    if( res == FALSE ){
        stop(paste0("Colnames of ", ImmPortTemplateName, " are not correct."))
    }
}

checkTypes <- function(df, templateDF, typeCol, ImmPortTemplateName){

    res <- sapply(seq(ncol(df)), FUN = function(x){
        all(typeof(df[[x]]) == types[[x]])
    })
    badCols <- colnames(df)[res == FALSE]

    if( any(res == FALSE) ){
       message("Type errors found in following columns: ")
       message(paste(badCols, collapse = "\n"))
       stop("Check data types for ", ImmPortTemplateName)
    }
}

checkRequired <- function(df, templateDF, ImmPortTemplateName){
    req <- templateDF$templateColumn[ templateDF$required == TRUE]
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
getLkVals <- function(lkTblNm, templateDF, lookupsDF, cv){
    colNm <- ifelse(cv == true, "cvTableName", "pvTableName")
    lkTbl <- templateDF[[colNm]][ templateDF$templateColumn == x ]
    lkVals <- lookupsDF$name[ lookupsDF$lookup == lkTbl ]
    if( any(grepl(";", lkVals)) ){
        lkVals <- unname(unlist(sapply(lkVals, function(y){ strsplit(y, ";") })))
    }
}

# Helper for comparing inputVals to lkVals
compareVals <- function(compCols, templateDF, lookupsDF, cv = FALSE){
    res <- sapply(compCols, FUN = function(x){
        lkVals <- getLkVals(x, templateDF, lookupsDF, cv)
        all(df[[x]] %in% lkVals)
    })
    if( any(res == FALSE) ){
        message("Columns with lookups having non-preferred or controlled values: ")
        message(paste(res[res == TRUE], collapse = "\n"))
    }
    return(res)
}

checkFormat <- function(df, templateDF, lookupsDF, ImmPortTemplateName){
    pvCols <- templateDF$templateColumn[ !is.na(templateDF$pvTableName) ]
    compareVals(pvCols, templateDF, lookupsDF, cv = FALSE)
    cvCols <- templateDF$templateColumn[ !is.na(templateDF$cvTableName) ]
    res <- compareVals(cvCols, templateDF, lookupsDF, cv = TRUE)
    if(any(res == FALSE)){
        stop(paste0(ImmPortTemplateName, " has non-controlled terms."))
    }
}

#' @export
checkObj <- function(df, ImmPortTemplateName){

    tblVars <- getTblVars(ImmPortTemplateName)

    templateDF <- getSingleTemplate(ImmPortTemplateName, tblVars$allDF, tblVars$tblNmCol)

    # template checks
    checkClass(df, ImmPortTemplateName)
    checkDim(df, templateDF, ImmPortTemplateName)
    checkColnames(df, ImmPortTemplateName, templateDF, tblVars$varCol )
    checkTypes(df, templateDF, tblVars$typeCol, ImmPortTemplateName)
    checkRequired(df, templateDF, ImmPortTemplateName)

    # format check using lookups
    reqLookups <- unique(templateDF$pvTableName)
    if( length(reqLookups) > 0 ){
        reqLookups <- reqLookups[ !is.na(reqLookups) ]
        lookupsDF <- ImmPortLookups[ ImmPortLookups$lookup %in% reqLookups, ]
        checkFormat(df, templateDF, lookupsDF, ImmPortTemplateName)
    }
}
