#' Convert date format YYWW to YYYY-MM-DD
#'
#' Since the exact date isn't given in the input, this function will set the
#' date to Monday of the week. As a precaution, a leading zero is added if it
#' has been removed. This can e.g., happen if the input was "0107" and has been
#' converted to a numeric 107. We need to export this function so that it can
#' be found when using Arrow to process the data.
#'
#' @param yyww Character(s) of the format YYWW.
#'
#' @returns Date(s) in the format YYYY-MM-DD.
#' @export
#'
#' @examples
#' \dontrun{
#' yyww_to_yyyymmdd("0101")
#' yyww_to_yyyymmdd("2402")
#' yyww_to_yyyymmdd("2453")
#' yyww_to_yyyymmdd(c("0102", "0304"))
#' yyww_to_yyyymmdd(c("0100", "0353"))
#' yyww_to_yyyymmdd(c("0953", "0701"))
#' yyww_to_yyyymmdd(953)
#' }
yyww_to_yyyymmdd <- function(yyww) {
  if (is.numeric(yyww)) {
    # Ensure input is zero-padded to length 4
    yyww <- sprintf("%04d", yyww)
  }

  # Extract year and week
  year <- stringr::str_sub(yyww, 1, 2)
  week <- stringr::str_sub(yyww, 3, 4)

  # Calculate the first day of the ISO year, which is when the first week
  # has most of the week days in it (4th of January, or the first Thursday).
  # See: https://en.wikipedia.org/wiki/ISO_week_date
  year_start <- lubridate::ymd(paste(year, "-01-04"))
  first_weekday <- lubridate::wday(year_start, week_start = 1)

  # Create the date, using the start of year, but setting the week from the
  # `yyww` argument. This forces the date to move to the correct week.
  date <- year_start
  lubridate::week(date) <- as.numeric(week)

  # Adjust the date to be Monday in that week. Need to add 1 since there is
  # no zero weekday (week starts on 1, the Monday).
  date - first_weekday + 1
}
