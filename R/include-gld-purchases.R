#' Include only purchases of glucose lowering drugs (GLD)
#'
#' But don't include glucose-lowering drugs that may be used for other
#' conditions than diabetes like GLP-RAs or dapagliflozin/empagliflozin drugs.
#' Since the diagnosis code data on pregnancies (see below) is insufficient to
#' perform censoring prior to 1997, [include_gld_purchases()] only extracts
#' dates from 1997 onward by default (if Medical Birth Register data is
#' available to use for censoring, the extraction window can be extended).
#'
#' @param lmdb The `lmdb` register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#'   Only rows with glucose lowering drug purchases are kept, plus some columns are renamed.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' simulate_registers("lmdb", 1000)[[1]] |> include_gld_purchases()
#' }
include_gld_purchases <- function(lmdb) {
  logic <- c(
    "is_gld_code"
  ) |>
    logic_as_expression()

  lmdb |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!logic$is_gld_code) |>
    # Rename columns for clarity.
    dplyr::rename(
      date = "eksd",
      indication_code = "indo"
    )
}
