% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/include-gld-purchases.R
\name{include_gld_purchases}
\alias{include_gld_purchases}
\title{Include only those who have a purchase of a glucose lowering drug (GLD).}
\usage{
include_gld_purchases(lmdb)
}
\arguments{
\item{lmdb}{The LMDB register.}
}
\value{
The same type as the input data, default as a \code{\link[tibble:tibble]{tibble::tibble()}}.
}
\description{
See \link{algorithm} for the logic used to filter these patients.
}
\examples{
\dontrun{
register_data$lmdb |> include_gld_purchases()
}
}
\keyword{internal}
