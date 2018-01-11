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
    stop("Check data for ", ImmPortTemplateName, ". ",
         "Required columns with NA or blank values: ",
         paste(required[res], collapse = ", ")
    )
  }

  invisible(NULL)
}

# Helper for comparing inputVals to lkVals
chkLookupVals <- function(metaByIdx, dfCol) {
    ipl <- Import2ImmPort::ImmPortLookups

    lkTblNm <- c(metaByIdx$pvTableName, metaByIdx$cvTableName)
    lkTblNm <- lkTblNm[ !is.na(lkTblNm) ]

    if (length(lkTblNm) > 0) {
        lkVals <- ipl$name[ipl$lookup == lkTblNm]

        if (any(grepl(";", lkVals))) {
            lkVals <- unname(unlist(sapply(lkVals, function(y) strsplit(y, ";"))))
        }

        res <- all(dfCol %in% lkVals)
    }else{
        res <- NULL
    }

    res
}

# TODO: rewrite to look for pv vs cv THEN do comparison and warnings / erros
checkFormat <- function(df, templateInfo, ImmPortTemplateName) {

  res <- sapply(seq(1:dim(df)[[2]]), function(index) {
    metaByIdx <- templateInfo[index, ]
    res <- chkLookupVals(metaByIdx, df[,index])
    if (metaByIdx$pv == TRUE && res == FALSE) {
        message("'", ImmPortTemplateName,
                "' has non-preferred terms in ",
                metaByIdx$templateColumn, " at index ",
                index)
    }else if (metaByIdx$cv == TRUE && res == FALSE) {
        stop("'", ImmPortTemplateName,
             "' has non-controlled terms in ",
             metaByIdx$templateColumn, " at index ",
             index)
    }
  })

}

###########################################
###          Main Function              ###
###########################################

#' @title Check template data frame
#'
#' @description Check template data frame based on class, dimensions, colnames,
#'     data types, and format.
#'
#' @param df data frame with user entered data and 'templateName' attribute
#' @export
checkTemplate <- function(df) {

  ImmPortTemplateName <- attr(df, "templateName")
  if (is.null(ImmPortTemplateName)) {
      stop("'templateName' attribute is not present. Please set with attr().")
  }

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
