#' Simple `as.Date()` wrapper.
#'
#' DuckDB doesn't support using [lubridate::as_date()], so this is
#' a simple wrapper around [as.Date()] with the correct formats.
#'
#' @param x A character (or date) column.
#'
#' @returns A Date column.
#' @keywords internal
as_date <- function(x) {
  as.Date(x, tryFormats = c("%Y%m%d", "%Y-%m-%d"))
}
