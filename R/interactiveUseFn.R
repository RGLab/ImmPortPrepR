###########################################
###      Interactive Use Functions      ###
###########################################

# ---- HELPER FN -----------------------------------------------------
# get single template info from larger ImmPortTemplates
# To get template DF, Have to use a range of row vals b/c some required
# rows do not have tableName. e.g. `required separator column`
getSingleTemplate <- function(ImmPortTemplateName, allDF, tblNmCol){
  templateRng <- range(grep(paste0("^", ImmPortTemplateName, "$") , allDF[[tblNmCol]] ))
  templateDF <- allDF[ templateRng[[1]]:templateRng[[2]], ]
}

# Create templateDF with flexibility for either bsd or ImmPortTemplates
# NOTE: matrix() must be called with blank strings otherwise is not
# editable by edit() in future.  Unsure why not.
makeTemplateDF <- function(templateInfo, tblNmCol, headerNmsCol){
  tmpDF <- data.frame(matrix("", ncol = length(templateInfo[[tblNmCol]]), nrow = 1),
                      stringsAsFactors = FALSE)
  colnames(tmpDF) <- templateInfo[[headerNmsCol]]
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

  ImmPortTemplates <- get("ImmPortTemplates") # In global env when library loaded
  basicStudyDesignTemplates <- get("basicStudyDesignTemplates")

  if( ImmPortTemplateName %in% unique(basicStudyDesignTemplates$Block) ){
    templateInfo <- getSingleTemplate(ImmPortTemplateName, basicStudyDesignTemplates, "Block")
    if( ImmPortTemplateName == "study" ){
      tmpDF <- data.frame(matrix("", ncol = 2, nrow = length(templateInfo$Block)),
                          stringsAsFactors = F)
      tmpDF[,1] <- templateInfo$Variable_Name
      colnames(tmpDF) <- NULL
    }else{
      tmpDF <- makeTemplateDF(templateInfo, "Block", "Variable_Name")
    }
  }else{
    templateInfo <- getSingleTemplate(ImmPortTemplateName, ImmPortTemplates, "tableName")
    tmpDF <- makeTemplateDF(templateInfo, "tableName", "tableColumn")
  }

  return(tmpDF)
}
