# Macro Average Specificity

This function computes the macro-average specificity for a multi-class
prediction model. It assumes that the *negative* class is the first one.

## Usage

``` r
macro_average_specificity_vec(
  truth,
  estimate,
  estimator = NULL,
  na_rm = TRUE,
  case_weights = NULL,
  event_level = "first",
  ...
)

macro_average_specificity(data, ...)

# S3 method for class 'data.frame'
macro_average_specificity(
  data,
  truth,
  estimate,
  estimator = NULL,
  na_rm = TRUE,
  case_weights = NULL,
  event_level = "first",
  ...
)
```

## Arguments

- truth:

  The column identifier for the true class results (that is a factor).

- estimate:

  The column identifier for the predicted class results (that is also
  factor).

- estimator:

  One of: "binary", "macro", "macro_weighted", or "micro" to specify the
  type of averaging to be done.

- na_rm:

  A logical value indicating whether NA values should be stripped before
  the computation proceeds.

- case_weights:

  The optional column identifier for case weights.

- event_level:

  A single string. Either "first" or "second" to specify which level of
  truth to consider as the "event". This argument is only applicable
  when estimator = "binary".

- ...:

  Currently unused.

- data:

  Either a data.frame containing the columns specified by the truth and
  estimate arguments, or a table/matrix where the true class results
  should be in the columns of the table.

## Value

A scalar storing the value of the macro-average specificity score.

## Examples

``` r
fold1 <- subset(yardstick::hpc_cv, Resample == "Fold01")
macro_average_specificity_vec(fold1$obs, fold1$pred)
#> [1] 0.7113796
macro_average_specificity(fold1, obs, pred)
#> # A tibble: 1 × 3
#>   .metric                   .estimator .estimate
#>   <chr>                     <chr>          <dbl>
#> 1 macro_average_specificity macro          0.711
```
