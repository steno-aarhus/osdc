#' Include only those who have a purchase of a glucose lowering drug (GLD).
#'
#' But don't include glucose-lowering drugs that may be used for other
#' conditions than diabetes like GLP-RAs or dapagliflozin/empagliflozin drugs.
#' Since the diagnosis code data on pregnancies (see below) is insufficient to
#' perform censoring prior to 1997, `include_gld_purchases()` only extracts
#' dates from 1997 onward by default (if Medical Birth Register data is
#' available to use for censoring, the extraction window can be extended).
#'
#' Additional columns added are 1) if an insulin purchase has been made within
#' 180 days of the first glucose-lowering drug purchase, 2) if two-thirds of
#' purchased glucose-lowering drug doses are insulin, and 3) if insulin is the
#' only glucose-lowering drug type ever purchased.
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
#'   -   `indication_code`: The indication code of the prescription (renamed
#'        from `indo`).
#'   -   `has_two_thirds_insulin`: A logical variable used in classifying type 1
#'       diabetes. See [algorithm()] for more details.
#'   -   `has_only_insulin_purchases`: A logical variable used in classifying type 1
#'       diabetes. See [algorithm()] for more details.
#'   -   `has_insulin_purchases_within_180_days`: A logical variable used in classifying type 1
#'       diabetes. See [algorithm()] for more details.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' simulate_registers("lmdb", 10000)[[1]] |> include_gld_purchases()
#' }
include_gld_purchases <- function(lmdb) {
  logic <- c(
    "is_insulin_gld_code",
    "is_gld_code"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression
    purrr::map(rlang::parse_expr)

  lmdb |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!logic$is_gld_code) |>
    # `volume` is the doses contained in the purchased package and `apk` is the
    # number of packages purchased
    dplyr::mutate(
      contained_doses = .data$volume * .data$apk,
      is_insulin_gld_code = !!logic$is_insulin_gld_code,
    ) |>
    # Rename columns for clarity.
    dplyr::rename(
      date = "eksd",
      indication_code = "indo"
    ) |>
    add_insulin_purchases_cols() |>
    # Keep only the columns we need.
    dplyr::select(
      "pnr",
      # Change to date to work with later functions.
      "date",
      "atc",
      "indication_code",
      "has_two_thirds_insulin",
      "has_only_insulin_purchases",
      "has_insulin_purchases_within_180_days"
    )
}

add_insulin_purchases_cols <- function(data) {
  logic <- c(
    "has_two_thirds_insulin",
    "has_only_insulin_purchases",
    "has_insulin_purchases_within_180_days"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression.
    purrr::map(rlang::parse_expr)

  insulin_cols <- data |>
    dplyr::mutate(date = lubridate::ymd(date)) |>
    dplyr::select(
      "pnr",
      "date",
      "contained_doses",
      "is_insulin_gld_code"
    ) |>
    dplyr::summarise(
      # Get first date of a GLD purchase and if a purchase of insulin occurs
      # within 180 day of the first purchase.
      first_gld_date = min(date, na.rm = TRUE),
      has_insulin_purchases_within_180_days = !!logic$has_insulin_purchases_within_180_days,
      # Sum up total doses of insulin and of all GLD.
      n_insulin_doses = sum(
        .data$contained_doses[.data$is_insulin_gld_code],
        na.rm = TRUE
      ),
      n_gld_doses = sum(.data$contained_doses, na.rm = TRUE),
      .by = "pnr"
    ) |>
    dplyr::mutate(
      # When at least two-thirds of the doses are insulin doses.
      has_two_thirds_insulin = !!logic$has_two_thirds_insulin,
      # When all doses are insulin.
      has_only_insulin_purchases = !!logic$has_only_insulin_purchases,
      .by = "pnr"
    ) |>
    dplyr::select(
      "pnr",
      "has_two_thirds_insulin",
      "has_only_insulin_purchases",
      "has_insulin_purchases_within_180_days"
    )

  data |>
    dplyr::left_join(insulin_cols, by = dplyr::join_by("pnr"))
}
