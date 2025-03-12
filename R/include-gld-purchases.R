#' Include only those who have a purchase of a glucose lowering drug (GLD).
#'
#' But don't include glucose-lowering drugs that may be used for other
#' conditions than diabetes like GLP-RAs or dapagliflozin/empagliflozin drugs.
#' Since the diagnosis code data on pregnancies (see below) is insufficient to
#' perform censoring prior to 1997, `include_gld_purchases()` only extracts
#' dates from 1997 onward by default (if Medical Birth Register data is
#' available to use for censoring, the extraction window can be extended).
#'
#' These events are then passed to a chain of exclusion functions:
#' `exclude_potential_pcos()` and `exclude_pregnancy()`.
#'
#' @param lmdb The `lmdb` register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()], in
#'   a long format with all dates of GLD purchases kept and the following
#'   variables:
#'
#'   -   `pnr`: Personal identification variable.
#'   -   `date`: The dates of all purchases of GLD.
#'   -   `atc`: The ATC code for the type of drug.
#'   -   `contained_doses`: The amount of doses purchased, in number of defined
#'       daily doses (DDD).
#'   -   `indication_code`: The indication code of the prescription (renamed
#'       from `indo`).
#'   -  `has_gld_purchases`: A logical variable to use as a helper indicator for
#'      later functions.
#'
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data$lmdb |> include_gld_purchases()
#' }
include_gld_purchases <- function(lmdb) {
  verify_required_variables(lmdb, "lmdb")
  criteria <- get_algorithm_logic("gld") |>
    # To convert the string into an R expression.
    rlang::parse_expr()
  lmdb |>
    column_names_to_lower() |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!criteria) |>
    # `volume` is the doses contained in the purchased package and `apk` is the
    # number of packages purchased
    dplyr::mutate(
      contained_doses = .data$volume * .data$apk,
      # An indicator variable for later joins
      has_gld_purchases = TRUE
    ) |>
    # Keep only the columns we need.
    dplyr::select(
      "pnr",
      # Change to date to work with later functions.
      date = "eksd",
      "atc",
      "contained_doses",
      "has_gld_purchases",
      indication_code = "indo"
    )
}
