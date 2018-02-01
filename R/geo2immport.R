#' @title Output ImmPort-compliant tsv files for gene expression matrices from GEO
#'
#' @description Given a GEO Series accession, geo2ImmPort will output a
#'
#' @param geoGSE string, GEO Series accession
#' @param outputFile string, filepath for output. default is NULL.
#' @importFrom GEOquery getGEO getGEOfile
#' @export
geo2ImmPort <- function(geoGSE, outputFile = NULL){

    # get GSE SOFT file
    tmpDir <- tempdir()
    dmp <- getGEOfile(geoGSE, destdir = tempDir)
    files <- list.files(tmpDir)
    file <- files[ grep(geoGSE, files) ]
    tmp <- getGEO(filename = file)

    # transform GSE class into dataFrame that can be written out (ImmPort compliant)
    tmpTbls <- lapply(names(tmp@gsms), function(x){
        tbl <- tmp@gsms[[x]]@dataTable@table
        colnames(tbl)[[2]] <- x
        return(tbl)
        })
    output <- Reduce(f = function(x,y){ merge(x,y, by = "ID_REF", all = T)}, tmpTbls)

    # write to outputFile
    if(!is.null(outputFile)){
        write.table(output, file = outputFile, quote = FALSE, row.names = FALSE)
    }

    return(output)
}
