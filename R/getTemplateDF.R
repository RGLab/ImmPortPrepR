###########################################
###      Interactive Use Functions      ###
###########################################
# ---- HELPER FN --------------------------
# Used in checkTemplate() and below
getSingleTemplate <- function(ImmPortTemplateName) {
  if (!(ImmPortTemplateName %in% unique(ImmPortTemplates$templateName))) {
    stop("Given template name is not in ImmPortTemplates$templateName. Please re-run.")
  }

  ImmPortTemplates[ImmPortTemplates$templateName == ImmPortTemplateName, ]
}

# Used in checkTemplate() and below
# Assume that that ImmPortTemplates$columnType is more accurate
# than ImmPortTemplates$jsonDataType
updateTypes <- function(columnType) {
  columnType <- gsub("varchar.+|clob|date", "character", columnType)
  columnType <- gsub("float|integer", "double", columnType)
  columnType[ is.na(columnType) ] <- "logical"

  columnType
}

# ---- MAIN FN --------------------------------------------------------
#' @title generate a template data frame for a given ImmPort Template Name
#'
#' @description Based on ImmPort's specifications, the function creates an
#'     empty dataframe with the correct column headers for the user to update
#'     as part of the ImmPort submission development.
#'
#' @param ImmPortTemplateName name of the ImmPort Template to create
#' @export
# Use method dynamically to generate DF for interactive work in preparing data.
# Template DFs are not kept as rda objects because the ImmPort tables and lookups
# can change with each data release.  Therefore using a function ensures that latest
# changes are all coming from same json files (templates and lookups) in the zip file
# at `http://www.immport.org/downloads/data/upload/templates/ImmPortTemplates.zip`.
getTemplateDF <- function(ImmPortTemplateName, rowNum = 1) {
  templateInfo <- getSingleTemplate(ImmPortTemplateName)

  templateInfo$columnType <- updateTypes(templateInfo$columnType)

  # create a temp data frame with template columns
  tmpDF <- data.frame(matrix("", ncol = nrow(templateInfo), nrow = rowNum),
                      stringsAsFactors = FALSE)
  colnames(tmpDF) <- templateInfo$templateColumn

  # update column type
  for (x in seq(1:length(templateInfo$columnType))) {
    changeType <- get(paste0("as.", templateInfo$columnType[x]))
    tmpDF[, x] <- changeType(tmpDF[, x])
  }

  tmpDF
}
