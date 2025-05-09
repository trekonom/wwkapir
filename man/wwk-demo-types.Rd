% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wwk-demographic-types.R
\name{wwk-demo-types}
\alias{wwk-demo-types}
\alias{wwk_demographic_types}
\title{Demographic Types}
\usage{
wwk_demographic_types(number = NULL, verbose = FALSE)
}
\arguments{
\item{number}{a vector of length 1. Optional number of dempgraphic type for which
meta data should be retrieved. Default to \code{NULL} in which case meta data
on all demographic type is returned.}

\item{verbose}{be verbose}
}
\value{
a tibble
}
\description{
Retrieves a list of demographic types from the
Wegweiser Kommune Open Data API.
}
\examples{
\dontrun{
wwk_demographic_types()
}
}
