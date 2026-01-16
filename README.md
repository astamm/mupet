
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mupet

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/mupet)](https://CRAN.R-project.org/package=mupet)
[![R-CMD-check](https://github.com/astamm/mupet/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/astamm/mupet/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/astamm/mupet/graph/badge.svg)](https://app.codecov.io/gh/astamm/mupet)
<!-- badges: end -->

The goal of {mupet} is to provide a performance evaluation toolkit for
multi-class prediction models in the form of metric functions compatible
with the [**tidymodels**](https://www.tidymodels.org) framework, through
the API designed in the
[{yardstick}](https://yardstick.tidymodels.org/index.html) package.

## Installation

You can install the package directly from CRAN using:

``` r
pak::pak("mupet")
```

Or you can install the development version of mupet like so:

``` r
# pak::pak("remotes")
remotes::install_github("astamm/mupet")
```
