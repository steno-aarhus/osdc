#' Convert column names to lower case.
#'
#' @param data An data frame type object.
#'
#' @return The same object type given.
#' @keywords internal
#'
#' @examples
#' tibble::tibble(A = 1:3, B = 4:6) |> columns_to_lower()
columns_to_lower <- function(data) {
  data |>
    dplyr::rename_with(tolower)
}
