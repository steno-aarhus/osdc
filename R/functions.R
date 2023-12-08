#' Create synthetic lab data
#'
#' @param num_samples Number of samples to create
#'
#' @return Data.frame with columns pnr, SAMPLINGDATE, ANALYSISCODE, and VALUE
create_test_lab_df <- function(num_samples) {
  data.frame(
    # pnr: patient ID (chr)
    # random ID's from 001-100 (even if num_samples > 100)
    pnr = sprintf("%03d", sample(1:100, num_samples, replace = TRUE)),

    # SAMPLINGDATE: date of sample (date)
    # random dates between 1995-01-01 and 2015-12-31
    SAMPLINGDATE = sample(
      seq(as.Date("1995-01-01"), as.Date("2015-12-31"), by = "day"),
      num_samples,
      replace = TRUE
    ),

    # ANALYSISCODE: npu code of analysis type (chr)
    # 50% is either NPU27300 or NPU03835
    # other 50% is 'NPU'+random sample from 10000:99999
    ANALYSISCODE = ifelse(
      # repeat 0 and 1 num_samples times and randomise them
      sample(rep(c(0, 1), length.out = num_samples)),
      # sample 'NPU27300' and 'NPU03835' for all 1's
      sample(c("NPU27300", "NPU03835"), num_samples, replace = TRUE),
      # sample NPU + random digit between 10000:99999 for all 0's
      paste0("NPU", sample(10000:99999, num_samples, replace = TRUE))
    ),

    # VALUE: numerical result of test (num)
    # random decimal number between 0.1-99.9
    VALUE = runif(num_samples, 0.1, 99.9)
  )
}
