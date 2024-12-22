#' Convert date format YYWW to YYYY-MM-DD
#'
#' Since the exact date isn't given in the input, this function will set the
#' date to Monday of the week.
#'
#' As a precaution, a leading zero is added if it has been removed
#' This can e.g., happen if the input was "0107" and has been converted to a
#' numeric 107.
#'
#' @param yyww Character(s) of the format yyww
#'
#' @returns Date(s) in the format YYYY-MM-DD.
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' yyww_to_yyyymmdd("0102")
#' yyww_to_yyyymmdd(c("0102", "0304"))
#' }
yyww_to_yyyymmdd <- function(yyww) {
  # ensure input is zero-padded to length 4
  yyww <- sprintf("%04d", as.numeric(yyww))

  year <- stringr::str_sub(yyww, 1, 2)
  week <- stringr::str_sub(yyww, 3, 4)

  # define helper variables
  first_day_of_iso_year <- lubridate::ymd(paste(year, "-01-04"))
  n_weekday_start_of_year <- lubridate::wday(first_day_of_iso_year, week_start = 1)

  # calculate date
  date <- first_day_of_iso_year
  lubridate::week(date) <- as.numeric(week)
  date <- date - n_weekday_start_of_year + 1 # adjust date to be Monday in that week

  return(date)
}
