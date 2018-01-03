###########################################
###          Helper Functions           ###
###########################################

checkClass <- function(df, dfName) {
  res <- class(df)[1] == "data.frame"

  if (!res) {
    stop(dfName, " data must be input as a data frame. Please re-format.")
  }

  invisible(NULL)
}

checkDim <- function(df, templateInfo, ImmPortTemplateName) {
  res <- ncol(df) == nrow(templateInfo)

  if (!res) {
    stop("Number of columns in ", ImmPortTemplateName, " is not correct.")
  }

  invisible(NULL)
}

checkColnames <- function(df, templateInfo, ImmPortTemplateName) {
  res <- all.equal(colnames(df), templateInfo$templateColumn)

  if (!res) {
    stop("Colnames of ", ImmPortTemplateName, " are not correct.")
  }

  invisible(NULL)
}

checkTypes <- function(df, templateInfo, ImmPortTemplateName) {
  templateInfo$jsonDataType <- updateTypes(templateInfo$jsonDataType)

  res <- mapply(function(x, y) typeof(x) == y, df, templateInfo$jsonDataType)
  
  badColumns <- colnames(df)[!res]

  if (any(!res)) {
    stop("Check data types for ", ImmPortTemplateName, "\n",
         "Type errors found in following columns: ",
         paste(badColumns, collapse = ", ")
    )
  }

  invisible(NULL)
}

checkRequired <- function(df, templateInfo, ImmPortTemplateName) {
  required <- templateInfo$templateColumn[templateInfo$required]
  
  res <- sapply(required, function(x) any(is.na(df[[x]]) || df[[x]] == ""))

  if (any(res)) {
    stop("Check data for ", ImmPortTemplateName, "\n",
         "Required columns with NA or blank values: ",
         paste(required[res], collapse = ", ")
    )
  }

  invisible(NULL)
}

# Helper for getting vector of lookup values
getLookupValues <- function(lkTblNm, templateInfo, lookupsDF, cv) {
  colNm <- ifelse(cv, "cvTableName", "pvTableName")
  lkTbl <- templateInfo[[colNm]][templateInfo$templateColumn == x]
  lkVals <- lookupsDF$name[lookupsDF$lookup == lkTbl]

  if (any(grepl(";", lkVals))) {
    lkVals <- unname(unlist(sapply(lkVals, function(y) strsplit(y, ";"))))
  }

  lkVals
}

# Helper for comparing inputVals to lkVals
compareValues <- function(compCols, templateInfo, lookupsDF, cv = FALSE) {
  res <- sapply(compCols, function(x) {
    lkVals <- getLookupValues(x, templateInfo, lookupsDF, cv)
    all(df[[x]] %in% lkVals)
  })

  if (any(!res)) {
    message("Columns with lookups having non-preferred or controlled values: ")
    message(paste(res[res], collapse = "\n"))
  }

  res
}

checkFormat <- function(df, templateInfo, lookupsDF, ImmPortTemplateName) {
  resPv <- NULL
  resCv <- NULL

  pvCols <- templateInfo$templateColumn[!is.na(templateInfo$pvTableName)]
  if (length(pvCols) > 0) {
    resPv <- compareValues(pvCols, templateInfo, lookupsDF, cv = FALSE)
  }

  cvCols <- templateInfo$templateColumn[!is.na(templateInfo$cvTableName)]
  if (length(pvCols) > 0) {
    resCv <- compareValues(cvCols, templateInfo, lookupsDF, cv = TRUE)
  }

  res <- c(resPv, resCv)

  if (!is.null(res) && any(!res)) {
    stop(ImmPortTemplateName, "has non-controlled terms.")
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
checkTemplate <- function(df, ImmPortTemplateName) {
  templateInfo <- getSingleTemplate(ImmPortTemplateName)

  # template checks
  checkClass(df, ImmPortTemplateName)
  checkDim(df, templateInfo, ImmPortTemplateName)
  checkColnames(df, templateInfo, ImmPortTemplateName)
  checkTypes(df, templateInfo, ImmPortTemplateName)

  # Allow empty tables for certain non-required sub-tables in BSD
  if (ImmPortTemplateName %in% c("study_file", "study_link", "study_pubmed")) {
    tmp <- unique(unname(unlist(df[1, ])))

    if (all(tmp == "" | is.na(tmp))) {
      message(paste0("skipping empty ", ImmPortTemplateName, " table"))
      return()
    }
  }

  checkRequired(df, templateInfo, ImmPortTemplateName)

  # format check using lookups
  pv <- templateInfo$pvTableName[!is.na(templateInfo$pvTableName)]
  cv <- templateInfo$cvTableName[!is.na(templateInfo$cvTableName)]
  allLookups <- c(pv,cv)
    
  if (length(allLookups) > 0) {
    lookupsDF <- ImmPortLookups[ImmPortLookups$lookup %in% allLookups, ]
    checkFormat(df, templateInfo, lookupsDF, ImmPortTemplateName)
  }
}
