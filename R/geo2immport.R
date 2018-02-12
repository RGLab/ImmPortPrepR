#' @title Output ImmPort-compliant tsv files for gene expression matrices from GEO
#'
#' @description Given a GEO Series accession, geo2ImmPort will output a
#'
#' @param geoGSE string, GEO Series accession
#' @param outputDir string, filepath for output. default is NULL.
#' @param stdNorm boolean, standardize and normalize exprMx.
#' @importFrom GEOquery getGEO getGEOfile
#' @importFrom preprocessCore normalize.quantiles
#' @export
geo2ImmPort <- function(geoGSE, outputDir = NULL, stdNorm = TRUE){

    # get GSE SOFT file
    tmpDir <- tempdir()
    dmp <- getGEOfile(geoGSE, destdir = tmpDir)
    files <- list.files(tmpDir)
    file <- files[ grep(geoGSE, files) ]

    tmp <- getGEO(filename = file)

    # transform GSE class results into dataFrame
    tmpTbls <- lapply(names(tmp@gsms), function(x){
        tbl <- tmp@gsms[[x]]@dataTable@table
        colnames(tbl)[[2]] <- x
        return(tbl)
    })
    exprs <- Reduce(f = function(x,y){ merge(x,y, by = "ID_REF", all = T)}, tmpTbls)

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

    # Create ImmPort experimentSamples.gene_expression_array template from metaData
    # meta <- getTemplateDF("experimentSamples.Gene_Expression_Array")

    # write to outputFile
    if(!is.null(outputDir)){
        write.table(exprs,
                    file = paste0(outputDir, "/", geoGSE, "_exprs.txt"),
                    sep = "\t",
                    quote = FALSE,
                    row.names = FALSE)

        # write.table(meta,
        #             file = paste0(outputDir, "/", geoGSE, "_expSmpls.txt"),
        #             sep = "\t",
        #             quote = FALSE,
        #             row.names = FALSE)
    }

    # return(list(exprs = exprs, expSmpls = meta))
    return(exprs)
}
