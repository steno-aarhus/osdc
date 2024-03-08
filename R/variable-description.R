#' Variables from registers and their descriptions that are required for the
#' OSDC algorithm.
#'
#' @format ## `variable_description`
#' A data frame with 39 rows and 6 columns:
#' \describe{
#'   \item{register_name}{The official, full Danish name of the register.}
#'   \item{register_abbrev}{The official abbreviation for the register.}
#'   \item{variable_name}{The official name of the variable found in the register.}
#'   \item{years_covered}{The years when the variable is available from.}
#'   \item{danish_description}{The official description in Danish for the variable.}
#'   \item{english_description}{The translated description in English for the variable.}
#' }
#' @source <https://www.dst.dk/extranet/forskningvariabellister/Oversigt%20over%20registre.html>
"variable_description"
