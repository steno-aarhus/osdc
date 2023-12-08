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

#' Create synthetic health insurance data
#'
#' @param num_samples Number of samples to create
#'
#' @return Data.frame with columns pnr, BARNMAK, SPECIALE, and HONUGE
create_test_hi_df <- function(num_samples) {
  data.frame(
    # pnr: patientID (chr)
    # random values from 001-100
    pnr = sprintf("%03d", sample(1:100, num_samples, replace = TRUE)),

    # BARNMAK: service performed on patient' child or not (binary)
    # 1 = child, 0 = not, 5% are 1's
    BARNMAK = sample(c(0, 1), num_samples, replace = TRUE,
                     prob = c(0.95, 0.05)),

    # SPECIALE: service code (6-digit int)
    # 50% random samples between 100000 and 600000
    # 50% random samples from 540000 to 549999
    SPECIALE = ifelse(
      # repeat 0 and 1 num_samples times and randomise them
      sample(rep(c(0, 1), length.out = num_samples)),
      # sample 100000:600000 for all 1's
      sample(100000:600000, num_samples, replace = TRUE),
      # sample 540000:549999 for all 0's
      sample(540000:549999, num_samples, replace = TRUE)
    ),

    # HONUGE: year/week of the service being billed (4-digit chr)
    # first and second digits are random numbers between 01-52
    # third and fourth digits are random numbers between 00-99
    HONUGE = sprintf(
      "%02d%02d",
      sample(1:52, num_samples, replace = TRUE),
      sample(0:99, num_samples, replace = TRUE)
    )
  )
}
