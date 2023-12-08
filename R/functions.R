#' Create synthetic lab data
#'
#' @param num_samples Number of samples to create
#'
#' @return Data.frame with columns pnr, SAMPLINGDATE, ANALYSISCODE, and VALUE
create_test_lab_df <- function(num_samples) {
  data.frame(
    # patient ID (will only include 001-100 even if num_samples > 100)
    pnr = sprintf("%03d", sample(1:100, num_samples, replace = TRUE)),
    # date of sample
    SAMPLINGDATE = sample(
      seq(as.Date("1995-01-01"), as.Date("2015-12-31"), by = "day"),
      num_samples, replace = TRUE),
    # npu code of analysis type (50% is either NPU27300 or NPU03835)
    ANALYSISCODE = ifelse(
      # repeat 1 and 2 num_samples times and randomise them
      sample(rep(c(1, 0), length.out = num_samples)),
      # sample 'NPU27300' and 'NPU03835' for all 1's
      sample(c('NPU27300', 'NPU03835'), num_samples, replace = TRUE),
      # sample NPU + random digit between 10000:99999 for all 0's
      paste0('NPU', sample(10000:99999, num_samples, replace = TRUE))),
    # numerical result of test
    VALUE = runif(num_samples, 0.1, 99.9)
  )
}
