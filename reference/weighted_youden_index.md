# Weighted Youden Index

This function computes the weighted Youden index for a multi-class
prediction model. It assumes that the *negative* class is the first one.

## Usage

``` r
weighted_youden_index_vec(
  truth,
  estimate,
  sensitivity_weight = 0.5,
  estimator = NULL,
  na_rm = TRUE,
  case_weights = NULL,
  event_level = "first",
  ...
)

weighted_youden_index(data, ...)

# S3 method for class 'data.frame'
weighted_youden_index(
  data,
  truth,
  estimate,
  sensitivity_weight = 0.5,
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

- sensitivity_weight:

  A scalar value specifying the weight to put on sensitivity. Defaults
  to `0.5` which puts equal weights to sensitivity and specificity.

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

A scalar storing the value of the weighted Youden index.

## Examples

``` r
fold1 <- subset(yardstick::hpc_cv, Resample == "Fold01")
weighted_youden_index_vec(fold1$obs, fold1$pred)
#> [1] 0.129896
weighted_youden_index(fold1, obs, pred)
#> # A tibble: 1 × 3
#>   .metric               .estimator .estimate
#>   <chr>                 <chr>          <dbl>
#> 1 weighted_youden_index macro          0.130
```
