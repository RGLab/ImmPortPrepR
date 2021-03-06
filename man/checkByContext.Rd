% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cleanTextFns.R
\name{checkByContext}
\alias{checkByContext}
\title{Check a character vector against words in ImmuneSpace}
\usage{
checkByContext(input)
}
\arguments{
\item{input}{character vector}
}
\description{
checkByContext compares non-stopwords in a vector to those
    already in ImmuneSpace. Any words not already in ImmuneSpace are analyzed
    via stringdist to find closest matches.  These matches are returned in a
    named list.
}
