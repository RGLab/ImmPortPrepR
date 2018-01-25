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

  res <- sapply(required, function(x) any(is.na(df[[x]]) || df[[x]] == ""))

  if (any(res)) {
    if (quiet) {
      return(res)
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

# TODO: rewrite to look for pv vs cv THEN do comparison and warnings / erros
checkFormat <- function(df, templateInfo, ImmPortTemplateName, quiet) {

  res <- sapply(seq(1:dim(df)[[2]]), function(index) {
    metaByIdx <- templateInfo[index, ]
    res <- R2i:::chkLookupVals(metaByIdx, df[,index])
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
  })
  
  names(res) <- colnames(df)
  res <- res[ !(sapply(res, is.null)) ]
  
  if (length(res) == 0) { res <- NULL }
  
  return(res)

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

  templateInfo <- R2i:::getSingleTemplate(ImmPortTemplateName) # for easier debugging

  # return object
  ret <- list()
  
  # template checks
  ret$class <- R2i:::checkClass(df, ImmPortTemplateName, quiet)
  ret$dim <- R2i:::checkDim(df, templateInfo, ImmPortTemplateName, quiet)
  ret$colnames <- R2i:::checkColnames(df, templateInfo, ImmPortTemplateName, quiet)
  
  if(chkTypes == TRUE){
    ret$types <- R2i:::checkTypes(df, templateInfo, ImmPortTemplateName, quiet)
  }
  

  # Allow empty tables for certain non-required sub-tables in BSD
  if (ImmPortTemplateName %in% c("study_file", "study_link", "study_pubmed")) {
    tmp <- unique(unname(unlist(df[1, ])))

    if (all(tmp == "" | is.na(tmp))) {
      message(paste0("skipping empty ", ImmPortTemplateName, " table"))
      return(ret)
    }
  }

  ret$required <- R2i:::checkRequired(df, templateInfo, ImmPortTemplateName, quiet)

  # format check using lookups
  if (any(templateInfo$pv | templateInfo$cv)) {
    ret$format <- R2i:::checkFormat(df, templateInfo, ImmPortTemplateName, quiet)
  }
  
  return(ret)
}
