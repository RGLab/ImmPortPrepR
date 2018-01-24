#' @title retrieve colnames for an ImmPort Template with associated lookup tables
#'
#' @description Some ImmPort Templates have controlled or preferred values
#'     for certain columns that are found in 'lookup' tables.  This function
#'     returns the colnames that have associated lookup tables.
#'
#' @param ImmPortTemplateName name of the ImmPort Template to check
#' @export
getIPLookups <- function(ImmPortTemplateName){
    ipt <- R2i::ImmPortTemplates
    tmp <- ipt[ ipt$templateName == ImmPortTemplateName, ]
    pvLookups <- tmp$templateColumn[ tmp$pv == TRUE ]
    if (length(pvLookups) > 0){
        message("Columns with Preferred Values:")
        message(paste(pvLookups, collapse = "\n"))
    }
    cvLookups <- tmp$templateColumn[ tmp$cv == TRUE ]
    if (length(cvLookups) > 0){
        message("Columns with Controlled Values:")
        message(paste(cvLookups, collapse = "\n"))
    }
    return(invisible(NULL))
}

#' @title retrieve allowed or preferred values for a given template and column
#'
#' @description Given a template and column, this function returns the values
#'    that are allowed or preferred for this entry.  The return object is a
#'    vector to make searching easier.
#'
#' @param ImmPortTemplateName ImmPort Template Name
#' @param templateColname column name in template
#' @export
getIPLookupValues <- function(ImmPortTemplateName, templateColname) {
    ipt <- R2i::ImmPortTemplates
    ipl <- R2i::ImmPortLookups

    tmp <- ipt[ ipt$templateName == ImmPortTemplateName &
                ipt$templateColumn == templateColname, ]

    #TODO: if( nrow(tmp) > 1 ){ warning("this table has two columns with the same name
        # that use a lookup" )}
        # make output list or df ... figure out what reads that in and change parsing

    lkTblNm <- c(tmp$pvTableName, tmp$cvTableName)
    lkTblNm <- lkTblNm[ !is.na(lkTblNm) ]
    lkVals <- ipl$name[ipl$lookup == lkTblNm]

    if (any(grepl(";", lkVals))) {
        lkVals <- unname(unlist(sapply(lkVals, function(y) strsplit(y, ";"))))
    }

    lkVals
}
