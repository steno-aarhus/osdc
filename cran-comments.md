## R CMD check results

0 errors | 0 warnings | 1 note

-   This is a new release.

## Testing

- We ran this locally on Windows, MacOS, and Ubuntu, as well as through GitHub
  Action workflows (using the release R version).  We ran devel and oldrel
  checks on the Ubuntu GitHub Action.
- We also ran on CRAN's win-builder.
- Only one of our tests had an issue with running on ubuntu devel R (on GitHub
  Actions), the other tests ran fine. We could not reproduce it locally nor on
  other platforms and R versions (release and oldrel). We set the one test to
  skip on CRAN, as we think it could be an issue in how our package interacts
  with one of our dependent packages and with devel R in this particular test
  case. We will be tracking this issue to see if it resolves itself downstream
  or when devel R becomes the release version.

