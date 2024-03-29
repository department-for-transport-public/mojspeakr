% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/internal_functions.R
\name{hash_sub}
\alias{hash_sub}
\title{Increase Rmarkdown headers by one level}
\usage{
hash_sub(x, sub_type)
}
\arguments{
\item{x}{string object to substitute one # value for another}

\item{sub_type}{logical or vector, TRUE will substitute all heading levels,
FALSE will substitute none, alternatively a vector will allow you
to select specific levels of header to substitute.}
}
\description{
Substitute hashed Rmarkdown headers with the next level down down
e.g. # to ##
}
\keyword{internal}
