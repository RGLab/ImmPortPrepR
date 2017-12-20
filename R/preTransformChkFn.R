###########################################
###    Pre-Transform Check Functions    ###
###########################################

checkClass <- function(df, dfName) {
  if(class(df)[1] != "data.frame") {
    stop(paste0(dfName, " data must be input as a data frame. Please re-format."))
  }
}

checkDim <- function(df, templateDF, ImmPortTemplateName){
    if( ncol(df) != nrow(templateDF) ){
        stop(paste0("Number of columns in ", ImmPortTemplateName, " is not correct."))
    }
}

checkColNames <- function(df, templateDF, ImmPortTemplateName){
    if( colnames(df) != templateDF$templateColumn ){
        stop(paste0("Colnames of ", dfName, " are not correct."))
    }
}

checkTypes <- function(df, templateDF, ImmPortTemplateName){
    types <- gsub("string", "character", templateDF$jsonDataType)
    types <- gsub("enum|number", "double", types)

    res <- sapply(seq(ncol(df)), FUN = function(x){
        all(typeof(df[[x]]) == types[[x]])
    })

    if( any(res == FALSE) ){
       badCols <- colnames(df)[!res]
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
checkObj <- function(df, ImmPortTemplateName, ImmPortLookups, ImmPortTemplates){

    # To get template DF, Have to use a range of row vals b/c some required
    # rows do not have tableName. e.g. `required separator column`
    templateRng <- range(grep(ImmPortTemplateName, ImmPortTemplates$tableName))
    templateDF <- ImmPortTemplates[ templateRng[[1]]:templateRng[[2]], ]

    # template checks
    checkClass(df, ImmPortTemplateName)
    checkDim(df, templateDF, ImmPortTemplateName)
    checkColnames(df, templateDF, ImmPortTemplateName)
    checkTypes(df, templateDF, ImmPortTemplateName)
    checkRequired(df, templateDF, ImmPortTemplateName)

    # format check using lookups
    reqLookups <- unique(templateDF$pvTableName)
    if( length(reqLookups) > 0 ){
        reqLookups <- reqLookups[ !is.na(reqLookups) ]
        lookupsDF <- ImmPortLookups[ ImmPortLookups$lookup %in% reqLookups, ]
        checkFormat(df, templateDF, lookupsDF, ImmPortTemplateName)
    }
}
