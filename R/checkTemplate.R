###########################################
###          Helper Functions           ###
###########################################

# CLASS
checkClass <- function(df, dfName, quiet) {
  res <- class(df)[1] == "data.frame"

  if (!res) {
    if (quiet) {
      return(FALSE)
    }else{
      stop(dfName, " data must be input as a data frame. Please re-format.")
    }
  }

  invisible(NULL)
}

# DIM
checkDim <- function(df, templateInfo, ImmPortTemplateName, quiet) {
  res <- ncol(df) == nrow(templateInfo)

  if (!res) {
    if (quiet) {
      return(FALSE)
    }else{
      stop("Number of columns in ", ImmPortTemplateName, " is not correct.")
    }
  }

  invisible(NULL)
}

# COLNAMES
checkColnames <- function(df, templateInfo, ImmPortTemplateName, quiet) {
  res <- identical(colnames(df), templateInfo$templateColumn)

  if (!res) {
    if (quiet) {
      return(FALSE)
    }else{
      stop("Colnames of ", ImmPortTemplateName, " are not correct.")
    }
  }

  invisible(NULL)
}

# TYPES
#' @importFrom utils capture.output
checkTypes <- function(df, templateInfo, ImmPortTemplateName, quiet) {
  demoDF <- data.frame(current = sapply(df, typeof),
                       target = updateTypes(templateInfo$jsonDataType),
                       stringsAsFactors = F)
  demoDF <- demoDF[ demoDF$current != demoDF$target, ]

  if (nrow(demoDF) > 0) {
    if (quiet) {
      return(demoDF)
    }else{
      stop("Correct data types for '", ImmPortTemplateName, "'\n",
           paste(capture.output(print(demoDF)), collapse = "\n"))
    }
  }

  invisible(NULL)
}

# REQUIRED
checkRequired <- function(df, templateInfo, ImmPortTemplateName, quiet) {
  required <- templateInfo$templateColumn[templateInfo$required]

  res <- sapply(required, function(x) any(is.na(df[[x]]) | df[[x]] == ""))
  res <- res[ res == TRUE ]

  if (any(res)) {
    if (quiet) {
      return(names(res))
    }else{
      stop("Check data for ", ImmPortTemplateName, ". ",
           "Required columns with NA or blank values: ",
           paste(required[res], collapse = ", ")
      )
    }
  }

  invisible(NULL)
}

# Helper for comparing inputVals to lkVals
chkLookupVals <- function(metaByIdx, dfCol) {
    ipl <- R2i::ImmPortLookups

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

# Only Throws error for controlled values being incorrect.
# Otherwise, to determine abnormal preferred values, quiet == FALSE
checkFormat <- function(df, templateInfo, ImmPortTemplateName, quiet) {

  res <- sapply(seq(1:dim(df)[[2]]), function(index) {
    metaByIdx <- templateInfo[index, ]

    valType <- if (metaByIdx$cv == TRUE) {
        "Controlled"
    } else if (metaByIdx$pv == TRUE) {
        "Preferred"
    } else {
        NA
    }
    if( !is.na(valType)) {
        res <- chkLookupVals(metaByIdx, df[,index])
    }else{
        res <- NA
    }

    if( quiet == FALSE ){
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
    }
    return(c(valType, res))
  })

  colnames(res) <- colnames(df)
  res <- res[ , res[2,] == FALSE & !is.na(res[2,]), drop = FALSE]
  cv <- colnames(res)[ res[1,] == "Controlled" ]

  if (length(cv) == 0) {
      return(NULL)
  } else {
      return(cv)
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
#' @param df data frame with user entered data and 'templateName' attribute
#' @param chkTypes boolean, TRUE by default, checks types of data by column
#' @param quiet boolean, TRUE by default, instead of errors, returns problems
#' @export
checkTemplate <- function(df, chkTypes = TRUE, quiet = TRUE) {

  ImmPortTemplateName <- attr(df, "templateName")
  if (is.null(ImmPortTemplateName)) {
      stop("'templateName' attribute is not present. Please set with attr().")
  }

  templateInfo <- getSingleTemplate(ImmPortTemplateName) # for easier debugging

  # return object
  ret <- list()

  # template checks
  ret$class <- checkClass(df, ImmPortTemplateName, quiet)
  ret$dim <- checkDim(df, templateInfo, ImmPortTemplateName, quiet)
  ret$colnames <- checkColnames(df, templateInfo, ImmPortTemplateName, quiet)

  if(chkTypes == TRUE){
    ret$types <- checkTypes(df, templateInfo, ImmPortTemplateName, quiet)
  }


  # Allow empty tables for certain non-required sub-tables in BSD only
  # after checking they have not been modified from the getTemplate() output.
  if (ImmPortTemplateName %in% c("study_file", "study_link", "study_pubmed")) {
    tmp <- unique(unname(unlist(df[1, ])))

    if (all(tmp == "" | is.na(tmp))) {
      message(paste0("skipping empty ", ImmPortTemplateName, " table"))
      return(NULL)
    }
  }

  ret$required <- checkRequired(df, templateInfo, ImmPortTemplateName, quiet)

  # format check using lookups
  if (any(templateInfo$pv | templateInfo$cv)) {
    ret$format <- checkFormat(df, templateInfo, ImmPortTemplateName, quiet)
  }

  # Feedback
  message(paste0(ImmPortTemplateName, ": ", length(ret), " Errors"))

  if(length(ret) == 0 ){ return(NULL) }

  return(ret)
}
