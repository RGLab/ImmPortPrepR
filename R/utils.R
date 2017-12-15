#########################################
###          Helper Functions         ###
#########################################

get_version <- function() {
  ver <- packageVersion("ImmPortPrepR")

  paste(ver[[1, 1]], ver[[1, 2]], sep = ".")
}