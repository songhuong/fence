% Generated by roxygen2 (4.0.2): do not edit by hand
\name{RF}
\alias{RF}
\title{Restricted Fence}
\usage{
RF(full, data, groups, B = 100, grid = 101, bandwidth = NA,
  plot = FALSE, method = c("marginal", "conditional"), id = "id",
  cpus = 2)
}
\arguments{
\item{full}{formular of full model}

\item{data}{data}

\item{B}{number of bootstrap sample, parametric for lmer}

\item{grid}{grid for c}

\item{bandwidth}{bandwidth for kernel smooth function}
}
\value{
list with whatever
}
\description{
Restricted Fence
}

