#########################################
###          Helper Functions         ###
#########################################

write_header <- function(name, file, version = get_version()) {
  schema_version <- paste("Schema Version", version)

  cat(name, schema_version,
      file = file, sep = "\t", fill = TRUE)
  cat("Please do not delete or edit this column",
      file = file, append = TRUE, fill = TRUE)
}

write_line <- function(file) {
  cat("\n", file = file, append = TRUE)
}

write_blockName <- function(blockName, file) {
  cat(blockName, file = file, append = TRUE, fill = TRUE)
}

write_table <- function(blockName, table, file) {
  stopifnot(is.data.frame(table))

  suppressWarnings(
    write.table(table, file = file, append = TRUE, quote = FALSE,
                sep = "\t", row.names = FALSE)
  )
}

write_list <- function(blockName, list, file) {
  stopifnot(is.list(list))

  table <- data.frame(names(list), unlist(list), stringsAsFactors = FALSE)

  suppressWarnings(
    write.table(table, file = file, append = TRUE, quote = FALSE,
                sep = "\t", row.names = FALSE, col.names = FALSE)
  )
}



#########################################
###          Main Function            ###
#########################################

write_txt <- function(name, blocks, file) {
  stopifnot(!is.null(names(blocks)))

  write_header(name, file)

  lapply(names(blocks), function(blockName) {
    write_line(file)
    write_blockName(blockName, file)

    if (class(blocks[[blockName]]) == "list") {
      write_list(blockName, blocks[[blockName]], file)
    } else {
      write_table(blockName, blocks[[blockName]], file)
    }
  })

  invisible(NULL)
}
