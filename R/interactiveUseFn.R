###########################################
###      Interactive Use Functions      ###
###########################################

# ---- HELPER FN -----------------------------------------------------
# get single template info from larger ImmPortTemplates
# To get template DF, Have to use a range of row vals b/c some required
# rows do not have tableName. e.g. `required separator column`
getSingleTemplate <- function(ImmPortTemplateName, ImmPortTemplates){
  templateRng <- range(grep(ImmPortTemplateName, ImmPortTemplates$tableName))
  templateDF <- ImmPortTemplates[ templateRng[[1]]:templateRng[[2]], ]
}

#' @export
# Use method dynamically to generate DF for interactive work in preparing data.
# Template DFs are not kept as rda objects because the ImmPort tables and lookups 
# can change with each data release.  Therefore using a function ensures that latest
# changes are all coming from same json files (templates and lookups) in the zip file
# at `http://www.immport.org/downloads/data/upload/templates/ImmPortTemplates.zip`. 
getTemplateDF <- function(ImmPortTemplateName){
  
  ImmPortTemplates <- get("ImmPortTemplates") # In global env when library loaded
  
  templateInfo <- getSingleTemplate(ImmPortTemplateName, ImmPortTemplates)
  
  if( ImmPortTemplateName != "study"){
    tmpDF <- data.frame(matrix(ncol = length(templateInfo$tableName), nrow = 1),
                        stringsAsFactors = FALSE)
    colnames(tmpDF) <- templateInfo$templateColumn
  }else{
    tmpDF <- data.frame(matrix(ncol = 2, nrow = length(templateInfo$tableName)),
                        stringsAsFactors = F)
    tmpDF[,1] <- templateInfo$templateColumn
  }
  
  return(tmpDF)
}