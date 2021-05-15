# ---- MAIN FN --------------------------------------------------------
#' @title get names of templates that can be retrieved via getTemplateDF
#'
#' @description returns vector of possible templates
#'
#' @export
getTemplateNames <- function() {
  return(unique(R2i::ImmPortTemplates$templateName))
}
