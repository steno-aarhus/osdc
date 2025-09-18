#' Drop rows with metformin purchases that are potentially for the treatment of polycystic ovary syndrome.
#'
#' Takes the output from [keep_gld_purchases()] and `bef` (information on sex and date
#' of birth) to do the exclusions.
#' This function only performs a filtering operation so outputs the same structure and
#' variables as the input from [keep_gld_purchases()], except the addition of a logical
#' helper variable `no_pcos` that is used in later functions.
#' After these exclusions are made, the output is used by `drop_pregnancies()`.
#'
#' @param gld_purchases The output from [keep_gld_purchases()].
#' @param bef The `bef` register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#'    It also has the same columns as [keep_gld_purchases()], except for a logical
#'    helper variable `no_pcos` that is used in later functions.
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lmdb", "bef"), 100)
#' drop_potential_pcos(
#'   gld_purchases = keep_gld_purchases(register_data$lmdb),
#'   bef = register_data$bef
#' )
#' }
drop_potential_pcos <- function(gld_purchases, bef) {
  logic <- logic_as_expression("is_not_metformin_for_pcos")[[1]]

  # Use the algorithm logic to drop potential PCOS
  gld_purchases |>
    dplyr::inner_join(bef, by = dplyr::join_by("pnr")) |>
    dplyr::mutate(
      date = lubridate::as_date(.data$date),
      foed_dato = lubridate::as_date(.data$foed_dato)
    ) |>
    # Use !! to inject the expression into filter
    dplyr::filter(!!logic) |>
    # Keep only the columns we need
    dplyr::select(
      -"koen",
      -"foed_dato"
    )
}
