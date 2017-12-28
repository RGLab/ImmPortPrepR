###########################################
###      Interactive Use Functions      ###
###########################################

# ---- HELPER FN -----------------------------------------------------
# get single template info from larger ImmPortTemplates
# To get template DF, Have to use a range of row vals b/c some required
# rows do not have tableName. e.g. `required separator column`
getSingleTemplate <- function(ImmPortTemplateName, ImmPortTemplates){
  templateRng <- range(grep(paste0("^", ImmPortTemplateName, "$") , ImmPortTemplates$tableName ))
  templateDF <- ImmPortTemplates[ templateRng[[1]]:templateRng[[2]], ]
}

# Create templateDF with flexibility for either bsd or ImmPortTemplates
# NOTE: matrix() must be called with blank strings otherwise is not
# editable by edit() in future.
makeTemplateDF <- function(templateInfo){

  tmpDF <- data.frame(matrix("", ncol = nrow(templateInfo), nrow = 1),
                      stringsAsFactors = FALSE)
  colnames(tmpDF) <- templateInfo$templateColumn

  templateInfo$jsonDataType <- gsub("string|date", "character", templateInfo$jsonDataType)
  templateInfo$jsonDataType <- gsub("number|enum|positive", "double", templateInfo$jsonDataType)

  for(x in seq(1:length(templateInfo$jsonDataType))){
      typeChg <- get(paste0("as.", templateInfo$jsonDataType[x] ))
      tmpDF[,x] <- typeChg(tmpDF[,x])
  }

  return(tmpDF)
}

# ---- MAIN FN --------------------------------------------------------
#' @export
# Use method dynamically to generate DF for interactive work in preparing data.
# Template DFs are not kept as rda objects because the ImmPort tables and lookups
# can change with each data release.  Therefore using a function ensures that latest
# changes are all coming from same json files (templates and lookups) in the zip file
# at `http://www.immport.org/downloads/data/upload/templates/ImmPortTemplates.zip`.
getTemplateDF <- function(ImmPortTemplateName){

  templateInfo <- getSingleTemplate(ImmPortTemplateName, ImmPortTemplates)
  tmpDF <- makeTemplateDF(templateInfo)

}
