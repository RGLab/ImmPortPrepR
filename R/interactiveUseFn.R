###########################################
###      Interactive Use Functions      ###
###########################################
# ---- HELPER FN --------------------------
# Used in CheckObj() and below
getSingleTemplate <- function(ImmPortTemplateName){
    templateInfo <- ImmPortTemplates[ ImmPortTemplates$templateName == ImmPortTemplateName, ]
}

# Used in CheckObj() and below
updateTypes <- function(templateInfo){
    templateInfo$jsonDataType <- gsub("string|date|enum", "character", templateInfo$jsonDataType)
    templateInfo$jsonDataType <- gsub("number|positive", "double", templateInfo$jsonDataType)
    return(templateInfo)
}

# ---- MAIN FN --------------------------------------------------------
#' @export
# Use method dynamically to generate DF for interactive work in preparing data.
# Template DFs are not kept as rda objects because the ImmPort tables and lookups
# can change with each data release.  Therefore using a function ensures that latest
# changes are all coming from same json files (templates and lookups) in the zip file
# at `http://www.immport.org/downloads/data/upload/templates/ImmPortTemplates.zip`.
getTemplateDF <- function(ImmPortTemplateName){

  templateInfo <- getSingleTemplate(ImmPortTemplateName)

  tmpDF <- data.frame(matrix("", ncol = nrow(templateInfo), nrow = 1),
                      stringsAsFactors = FALSE)
  colnames(tmpDF) <- templateInfo$templateColumn

  templateInfo <- updateTypes(templateInfo)

  for(x in seq(1:length(templateInfo$jsonDataType))){
      typeChg <- get(paste0("as.", templateInfo$jsonDataType[x] ))
      tmpDF[,x] <- typeChg(tmpDF[,x])
  }

  return(tmpDF)

}
