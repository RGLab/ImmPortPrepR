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
  reqFields <- chkVals$Variable_Name[chkVals$Required]
  presentFields <- colnames(df)[colSums(is.na(df), df == "" | df == " ") == 0]
  if(identical(setdiff(reqFields, presentFields)) != character(0){
    stop(paste0(dfName," required fields missing"))
  }
}

checkObj <- function(df, chkVals, dfName){
    checkClass(df, dfName)
    checkDim(df, chkVals, dfName)
    checkColnames(df, chkVals, dfName)
    checkTypes(df, chkVals, dfName)
}
