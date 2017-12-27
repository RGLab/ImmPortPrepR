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
# editable by edit() in future.
makeTemplateDF <- function(templateInfo, tblNmCol, varCol, typeCol){
  tmpDF <- data.frame(matrix("", ncol = length(templateInfo[[tblNmCol]]), nrow = 1),
                      stringsAsFactors = FALSE)
  colnames(tmpDF) <- templateInfo[[varCol]]
  for(x in seq(1:length(templateInfo[[typeCol]]))){
      typeChg <- get(paste0("as.", templateInfo[[typeCol]][x] ))
      tmpDF[,x] <- typeChg(tmpDF[,x])
  }
  return(tmpDF)
}

# Is template name in basicStudyDesign?
inBSD <- function(ImmPortTemplateName){
  return( ImmPortTemplateName %in% unique(basicStudyDesignTemplates$Block) )
}

# To use same logic when pulling info from either bsd or immportTemplates
getTblVars <- function(ImmPortTemplateName){
  if( inBSD(ImmPortTemplateName) == TRUE ){
    allDF <- basicStudyDesignTemplates
    tblNmCol <- "Block"
    varCol <- "Variable_Name"
    typeCol <- "Variable_Type"
  }else{
    allDF <- ImmPortTemplates
    tblNmCol <- "tableName"
    varCol <- "templateColumn"
    typeCol <- "jsonDataType"
  }

  res <- list(allDF = allDF,
              tblNmCol = tblNmCol,
              varCol = varCol,
              typeCol = typeCol)
}

# ---- MAIN FN --------------------------------------------------------
#' @export
# Use method dynamically to generate DF for interactive work in preparing data.
# Template DFs are not kept as rda objects because the ImmPort tables and lookups
# can change with each data release.  Therefore using a function ensures that latest
# changes are all coming from same json files (templates and lookups) in the zip file
# at `http://www.immport.org/downloads/data/upload/templates/ImmPortTemplates.zip`.
getTemplateDF <- function(ImmPortTemplateName){

  # note: ImmPortTemplates and basicStudyDesignTemplates are pulled from global env

  tblVars <- getTblVars(ImmPortTemplateName)

  templateInfo <- getSingleTemplate(ImmPortTemplateName, tblVars$allDF, tblVars$tblNmCol)

  if( ImmPortTemplateName %in% c("study", "study_2_protocol")  ){
    tmpDF <- data.frame(matrix("", ncol = 2, nrow = length(templateInfo[[tblVars$tblNmCol]])),
                        stringsAsFactors = F)
    tmpDF[,1] <- templateInfo[[tblVars$varCol]]
    colnames(tmpDF) <- NULL
  }else{
    tmpDF <- makeTemplateDF(templateInfo, tblVars$tblNmCol, tblVars$varCol, tblVars$typeCol)
  }

  return(tmpDF)
}
