% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-algorithm-logic.R
\name{get_algorithm_logic}
\alias{get_algorithm_logic}
\title{Get the criteria algorithmic logic and convert to an R logic condition.}
\usage{
get_algorithm_logic(criteria, algorithm_logic = algorithm)
}
\arguments{
\item{criteria}{The name of the inclusion or exclusion criteria to use.}
}
\value{
A character string.
}
\description{
Get the criteria algorithmic logic and convert to an R logic condition.
}
\examples{
\dontrun{
get_algorithm_logic("hba1c")
get_algorithm_logic("gld")
}
}
\keyword{internal}
