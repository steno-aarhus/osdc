#' Convert date format wwyy to ymd
#'
#' This function assumes that date is the first day of the week (Monday).
#'
#' @param wwyy Character of the format week year
#'
#' @return Date in format ymd
#'
#' @examples
wwyy_to_date <- function(wwyy) {
  # extract week and year
  ## if week < 10 (i.e., wwyy only has three characters), add a leading zero
  wwyy <- ifelse(stringr::str_length(wwyy) == 3, paste0("0", wwyy), wwyy)
  week <- as.numeric(stringr::str_sub(wwyy, 1, 2))
  year <- as.numeric(stringr::str_sub(wwyy, 3, 4))

  # define helper variables
  start_of_year <- lubridate::ymd(paste(year, "-01-04")) # first day of ISO year
  wday_start_of_year <- lubridate::wday(start_of_year, week_start = 1)

  # calculate date
  date <- start_of_year # set date to start of year
  lubridate::week(date) <- week # add week
  date <- date - wday_start_of_year + 1 # adjust date to start of that week

  return(date)
}
