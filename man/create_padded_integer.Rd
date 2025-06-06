% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate-registers.R
\name{create_padded_integer}
\alias{create_padded_integer}
\title{Create a vector of reproducible, random zero-padded integers.}
\usage{
create_padded_integer(n, length)
}
\arguments{
\item{n}{The number of integer strings to generate.}

\item{length}{The length of the padded integer strings.}
}
\value{
A character vector of integers.
}
\description{
For a given number of generated integers that are the same length, they will
always be identical. This makes it easier to do joining by
values that represent people, e.g. in \code{pnr}, \code{cpr}, \code{recnum} and
\code{dw_ek_kontakt}.
}
\examples{
\dontrun{
create_padded_integer(n = 10, length = 13)
}
}
\keyword{internal}
