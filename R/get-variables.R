
#' Get a list of the registers' abbreviations.
#'
#' @return A character string.
#' @export
#'
#' @examples
#' get_register_abbrev()
get_register_abbrev <- function() {
  unique(required_variables$register_abbrev)
}
