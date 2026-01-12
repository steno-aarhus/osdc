## Fix: Don't download from URL

We intended to remove the download from URL and instead create it as
a `sysdata.rda` file in the package before initially submitting to CRAN.
But we missed that TODO item. We have now fixed this so that CRAN checks
can pass without internet access. 

## R CMD check results

0 errors | 0 warnings | 0 note

## Testing

- We ran this locally on Windows, MacOS, and Ubuntu, as well as through GitHub
  Action workflows (using the release R version).  We ran devel and oldrel
  checks on the Ubuntu GitHub Action.
- We also ran on CRAN's win-builder.

