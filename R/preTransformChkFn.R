###########################################
###    Pre-Transform Check Functions    ###
###########################################

checkClass <- function(df, dfName) {
  if(class(df)[1] != "data.frame") {
    stop(paste0(dfName, " data must be input as a data frame. Please re-format."))
  }
}

checkDim <- function(df, chkVals, dfName){
    inputFormat <- chkVals$Format[ grep(paste0("^", dfName, "$"),
                                        chkVals$Block) ]

    errStatement <- paste0("Dimensions of ", dfName, " are not correct.")

    if( unique(inputFormat) == "list" ){
        if( dim(df) != c(2, length(inputFormat)) ){ stop(errStatement) }
    }else{
        if( ncol(df) != length(inputFormat) ){ stop(errStatement) }
    }
}

checkColNames <- function(df, chkVals, dfName){
    if( colnames(df) != chkVals$Variable_Name[ grep(paste0("^", dfName, "$"),
                                                    chkVals$Block) ] ){
        stop(paste0("Colnames of ", dfName, " are not correct."))
    }
}

checkTypes <- function(df, chkVals, dfName){
    if( colnames(df) != chkVals$Variable_Type[ grep(paste0("^", dfName, "$"),
                                                    chkVals$Block) ] ){
        stop(paste0( dfName, " object types are not correct."))
    }
}

checkRequired <- function(df, chkVals, dfName){
  blockdf <- chkVals[ grepl(paste0("^", dfName, "$"), chkVals$Block), ]
  reqFields <- blockdf$Variable_Name[blockdf$Required]
  presentFields <- colnames(df)[colSums(is.na(df)| df == "" | df == " ") == 0]
  if(identical(setdiff(reqFields, presentFields), character(0)) != TRUE ){
    stop(paste0(dfName," required fields are missing"))
  }
}

# TODO - checkFormat(df, chkVals, dfName)
# if any of the "format" cells are not empty
# parse semi-colon delimited string
# compare values in target col vs allowed vals
# determine if Non-Controlled terms allowed depending on chkVals "allowNC = TRUE"
# Msg / warning if non-controlled terms passed through

checkObj <- function(df, chkVals, dfName){
    checkClass(df, dfName)
    checkDim(df, chkVals, dfName)
    checkColnames(df, chkVals, dfName)
    checkRequired(df, chkVals, dfName)
    checkTypes(df, chkVals, dfName)
}
