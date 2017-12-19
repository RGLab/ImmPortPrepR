###########################################
###    Pre-Transform Check Functions    ###
###########################################

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

checkObj <- function(df, chkVals, dfName){

    if( class(df) != "data.frame" ){
        stop(paste0(dfName, " data must be input as a data frame. Please re-format."))
    }

    checkDim(df, chkVals, dfName)
    checkColnames(df, chkVals, dfName)
    checkTypes(df, chkVals, dfName)
}
