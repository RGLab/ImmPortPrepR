#########################################
###          Helper Functions         ###
#########################################

#' @importFrom utils packageVersion
get_version <- function() {
  ver <- packageVersion("Import2ImmPort")

  paste(ver[[1, 1]], ver[[1, 2]], sep = ".")
}