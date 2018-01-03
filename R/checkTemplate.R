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
  res <- identical(colnames(df), templateInfo$templateColumn)

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

#' @export
# Helper for showing user which columns have lookups in a template
getLookups <- function(ImmPortTemplateName){
    tmp <- ImmPortTemplates[ ImmPortTemplates$templateName == ImmPortTemplateName, ]
    pvLookups <- tmp$templateColumn[ tmp$pv == TRUE ]
    if (length(pvLookups) > 0){
        message("Columns with Preferred Values:")
        message(paste(pvLookups, collapse = "\n"))
    }
    cvLookups <- tmp$templateColumn[ tmp$cv == TRUE ]
    if (length(cvLookups) > 0){
        message("Columns with Controlled Values:")
        message(paste(cvLookups, collapse = "\n"))
    }
    return()
}

#' @export
# Helper for getting vector of lookup values from template and column names
getLookupValues <- function(ImmPortTemplateName, templateColname) {
  tmp <- ImmPortTemplates[ ImmPortTemplates$templateName == ImmPortTemplateName &
                               ImmPortTemplates$templateColumn == templateColname, ]
  lkTblNm <- dplyr::coalesce(tmp$pvTableName, tmp$cvTableName)
  lkVals <- ImmPortLookups$name[ImmPortLookups$lookup == lkTblNm]

  if (any(grepl(";", lkVals))) {
    lkVals <- unname(unlist(sapply(lkVals, function(y) strsplit(y, ";"))))
  }

  lkVals
}

# Helper for comparing inputVals to lkVals
compareValues <- function(compCols, ImmPortTemplateName, df) {
  res <- sapply(compCols, function(x) {
    lkVals <- getLookupValues(ImmPortTemplateName, x)
    all(df[[x]] %in% lkVals)
  })
}

checkFormat <- function(df, templateInfo, ImmPortTemplateName) {
  pvCols <- templateInfo$templateColumn[!is.na(templateInfo$pvTableName)]
  if (length(pvCols) > 0) {
    resPv <- compareValues(pvCols, ImmPortTemplateName, df)
    if (any(!resPv)) {
        message("'", ImmPortTemplateName, "' template using non-preferred terms in following cols:")
        message(paste(names(resPv)[!resPv], collapse = "\n"))
    }
  }

  cvCols <- templateInfo$templateColumn[!is.na(templateInfo$cvTableName)]
  if (length(cvCols) > 0) {
    resCv <- compareValues(cvCols, ImmPortTemplateName, df)
    if (any(!resCv)) {
        message("'", ImmPortTemplateName, "' template using non-controlled terms in following cols:")
        message(paste(names(resCv)[!resCv], collapse = "\n"))
        stop("Please correct and re-run.")
    }
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
  if (any(templateInfo$pv | templateInfo$cv)) {
    checkFormat(df, templateInfo, ImmPortTemplateName)
  }
}
