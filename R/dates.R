#' Translate to SQL for datetime conversion to eventually date
#'
#' DuckDB doesn't support using [lubridate::as_date()], so this
#' uses [dbplyr::sql()] to directly use DuckDB's `strptime` to
#' convert strings to datetimes. Afterwards, it can be converted
#' to dates.
#'
#' @param x A character (or date) column, in quotes.
#'
#' @returns A Datetime column.
#' @keywords internal
as_sql_datetime <- function(x) {
  dbplyr::sql(glue::glue("strptime({x}, ['%Y%m%d', '%Y-%m-%d'])"))
}
