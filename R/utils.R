#########################################
###          Helper Functions         ###
#########################################

#' @importFrom utils packageVersion
get_version <- function() {
  ver <- packageVersion("R2i")

  paste(ver[[1, 1]], ver[[1, 2]], sep = ".")
}
