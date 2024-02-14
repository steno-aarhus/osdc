# osdc: Open Source Diabetes Classifier for Danish Registers

<!-- badges: start -->

[![R-CMD-check](https://github.com/steno-aarhus/osdc/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/steno-aarhus/osdc/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

The goal of *osdc* is to provide an algorithm for classifying diabetes
within the Danish registers that is flexible and convenient to use, and
validated in terms of accuracy. While there are a few algorithms used
throughout Denmark for Danish register research, they are usually
textual descriptions of how to do it, rather than code-based
descriptions (e.g. the [Register of Selected Chronic
Diseases](https://www.esundhed.dk/-/media/Files/Publikationer/Emner/Operationer-og-diagnoser/Udvalgte-kroniske-sygdomme-svaere-psykiske-lidelser/Algoritmer-for-Udvalgte-Kroniske-Sygdomme-og-svre-psykiske-lidelser-RUKS-2022.ashx).
In this project, we aim to make it easier and more explicit how to
classify type 1 and type 2 diabetes within a Danish register context.
The original implementation of the algorithm is validated in a
peer-reviewed publication [here](https://doi.org/10.2147/clep.s407019),
but we expect to make tweaks to the algorithm over time. Any changes
will be transparent in the *osdc* repository.

## Installation

You can install the development version of osdc from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("steno-aarhus/osdc")
```

## Code of Conduct

Please note that the osdc project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

