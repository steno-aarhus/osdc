# Previous CRAN check issue

We initially submitted this and there was an error in the Windows
builder on CRAN. We could not reproduce it locally, nor on the CI
servers, nor on the CRAN winbuilder. We think it's because of a recent
update to duckplyr on Windows that caused this error. duckplyr has
created a fix for this: <https://github.com/duckdb/duckdb/pull/22844>.

## R CMD check results

0 errors | 0 warnings | 0 note

## Testing

- We ran this locally on Windows, MacOS, and Ubuntu, as well as through
  GitHub Action workflows (using the release R version). We ran devel
  and oldrel checks on the Ubuntu GitHub Action.
- We also ran on CRAN's win-builder.
