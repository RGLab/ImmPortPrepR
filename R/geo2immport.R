#' @title Output ImmPort-compliant tsv files for gene expression matrices from GEO
#'
#' @description Given a GEO Series accession, geo2ImmPort will output a
#'
#' @param softGzPath string, GEO .soft.gz local filepath
#' @param outputDir string, filepath for output. default is NULL.
#' @param stdNorm boolean, standardize and normalize exprMx.
#' @importFrom GEOquery getGEO getGEOfile
#' @importFrom preprocessCore normalize.quantiles
#' @import ImmuneSpaceR
#' @export
geo2ImmPort <- function(softGzPath, outputDir = NULL, stdNorm = TRUE){

    # get GSE class from .soft.gz local file
    tmp <- getGEO(filename = softGzPath)

    # transform GSE class results into dataFrame
    tmpTbls <- lapply(names(tmp@gsms), function(x){
        tbl <- tmp@gsms[[x]]@dataTable@table
        colnames(tbl)[[2]] <- x
        return(tbl)
    })
    exprs <- Reduce(f = function(x,y){ merge(x,y, by = "ID_REF", all = T)}, tmpTbls)
    rownames(exprs) <- exprs$ID_REF
    exprs <- exprs[,-1] # rm ID_REF

    # Taken from LabKeyModules/HIPCMatrix/pipeline/tasks/CreateMatrix.R fn - .microArrayPipe()
    if(stdNorm == TRUE){
        cnames <- colnames(exprs)
        rnames <- rownames(exprs)
        exprs <- preprocessCore::normalize.quantiles(exprs)
        colnames(exprs) <- cnames
        rownames(exprs) <- rnames
        exprs <- pmax(exprs, 1)
        if( max(exprs) > 100 ){ exprs <- log2(exprs) }
    }

    # write to outputFile
    if(!is.null(outputDir)){
        write.table(exprs,
                    file = paste0(outputDir, "/", geoGSE, "_exprs.txt"),
                    sep = "\t",
                    quote = FALSE,
                    row.names = TRUE)
    }

    return(exprs)
}
