#########################################
###          Helper Functions         ###
#########################################

write_header <- function(name, file, version = get_version(), extras = FALSE) {
  schema_version <- paste("Schema Version", version)

  # Update in v3.18
  if(name == "experimentSamples.RNA_Sequencing"){
      name <- "rna_sequencing"
  }else if(name == "reagents.Sequencing"){
      name <- "sequencing_reagents"
  }

  cat(name, schema_version,
      file = file, sep = "\t", fill = TRUE)
  cat("Please do not delete or edit this column",
      file = file, append = TRUE, fill = TRUE)
  if (extras) {
    cat("Validation Level", "Standard",
        file = file, sep = "\t", append = TRUE, fill = TRUE)
    cat("Column Name",
        file = file, append = TRUE, fill = TRUE)
  }
}

write_line <- function(file) {
  cat("\n", file = file, append = TRUE)
}

write_blockName <- function(blockName, file) {
  cat(blockName, file = file, append = TRUE, fill = TRUE)
}

#' @importFrom utils write.table
write_table <- function(table, file, addColumnName = TRUE) {
  stopifnot(is.data.frame(table))

  if (addColumnName) {
    table <- cbind(data.frame("Column Name" = "", check.names = FALSE), table)
  }

  suppressWarnings(
    write.table(table, file = file, append = TRUE, quote = FALSE,
                sep = "\t", row.names = FALSE, na = "")
  )
}

#' @importFrom utils write.table
write_list <- function(list, file) {
  stopifnot(is.list(list))

  table <- data.frame(names(list), unlist(list), stringsAsFactors = FALSE)

  suppressWarnings(
    write.table(table, file = file, append = TRUE, quote = FALSE,
                sep = "\t", row.names = FALSE, col.names = FALSE)
  )
}

write_emptyTable <- function(varNames, file, addColumnName = TRUE) {
  stopifnot(is.character(varNames))

  if (addColumnName) {
    varNames <- c("Column Name" = "", varNames)
  }

  cat(varNames, file = file, sep = "\t", fill = TRUE, append = TRUE)
}



#########################################
###          Main Function            ###
#########################################

#' Write a list of blocks to a text file
#'
#' @param name A character of the name.
#' @param blocks A list of blocks (lists or data.frames).
#' @param file A character of the file path.
#'
#' @return returns NULL invisibly.
write_txt <- function(name, blocks, file) {
  stopifnot(!is.null(names(blocks)))

  addColumnName <- name != "basic_study_design"
  extras <- name == "basic_study_design"

  write_header(name, file, extras = extras)

  lapply(names(blocks), function(blockName) {
    if( name == "basic_study_design" ){
        write_line(file)
        write_blockName(blockName, file)
    }

    block <- blocks[[blockName]]
    blockClass <- class(block)[1]
    if (blockClass == "list") {
      write_list(block, file)
    } else if (blockClass == "character") {
      write_emptyTable(block, file, addColumnName)
    } else if (blockClass == "data.frame") {
      write_table(block, file, addColumnName)
    } else {
      stop("block should be list, data frame, or character vector.")
    }
  })

  invisible(NULL)
}
