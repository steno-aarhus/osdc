% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate-registers.R
\name{insertion_rate}
\alias{insertion_rate}
\title{Generate logic based on a probability}
\usage{
insertion_rate(proportion)
}
\arguments{
\item{proportion}{A double between 0 and 1.}
}
\value{
A logic vector. TRUE if the random number is less than the
proportion, otherwise FALSE.
}
\description{
Generate logic based on a probability
}
\examples{
\dontrun{
insertion_rate(0.3)
}
}
\keyword{internal}
