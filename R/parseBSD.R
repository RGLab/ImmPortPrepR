# helper for subsetting
subsetBSD <- function(tblName, bsdDF){
  blanks <- grep("^$", bsdDF[[1]])
  startLn <- grep(paste0("^", tblName, "$"), bsdDF[[1]]) + 1
  endLn <- blanks[ blanks > startLn ][[1]] - 1
  subDF <- bsdDF[ startLn : endLn, ]
  
  if(tblName == "study"){
    subDF <- subDF[ , !(grepl("^X", colnames(subDF))) ]
    subDF <- data.frame(t(subDF), stringsAsFactors = F)
    rownames(subDF) <- NULL
    colnames(subDF) <- subDF[1, ]
    subDF <- subDF[-1, ] 
  }else{
    colnames(subDF) <- subDF[1, ]
    subDF <- subDF[-1, ] 
    subDF <- subDF[ , !(grepl("^$|^\\.", colnames(subDF))) ]
  }
  
  attr(subDF, "templateName") <- tblName # Important for checkTemplate()!
  
  return(subDF)
}


#' @title parse the basic study design template and return a list of R data frames
#'
#' @description function parses a csv version of the basic study design template
#'     from ImmPort to generate a list of R data frames that can then be checked with
#'     the quality control functions in the package.
#'
#' @param filePath file path for basic study design csv. Cannot be excel spreadsheet.
#' @importFrom utils read.csv
#' @importFrom data.table fread
#' @export
parseBSD <- function(filePath){
  # read in csv, txt
  bsdDF <- fread(filePath, fill = T, stringsAsFactors = F)
  
  # break up into segments and generate return object
  tbls <- c("study", 
            "arm_or_cohort",
            "inclusion_exclusion",
            "planned_visit",
            "study_2_protocol",
            "study_file",
            "study_link",
            "study_personnel",
            "study_pubmed")
  
  res <- sapply(tbls, subsetBSD, bsdDF = bsdDF )
  
}

