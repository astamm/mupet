#' Weighted Youden Index
#'
#' This function computes the weighted Youden index for a multi-class prediction model.
#' It assumes that the *negative* class is the first one.
#'
#' @param data Either a data.frame containing the columns specified by the truth and estimate
#' arguments, or a table/matrix where the true class results should be in the columns of the table.
#' @param truth The column identifier for the true class results (that is a factor).
#' @param estimate The column identifier for the predicted class results (that is also factor).
#' @param sensitivity_weight A scalar value specifying the weight to put on sensitivity.
#'   Defaults to `0.5` which puts equal weights to sensitivity and specificity.
#' @param estimator One of: "binary", "macro", "macro_weighted", or "micro" to specify the type of averaging to be done.
#' @param na_rm A logical value indicating whether NA values should be stripped before the computation proceeds.
#' @param case_weights The optional column identifier for case weights.
#' @param event_level A single string. Either "first" or "second" to specify which level of truth to consider as the "event".
#' This argument is only applicable when estimator = "binary".
#' @param ... Currently unused.
#'
#' @returns A scalar storing the value of the weighted Youden index.
#'
#' @name weighted_youden_index
#' @examples
#' fold1 <- subset(yardstick::hpc_cv, Resample == "Fold01")
#' weighted_youden_index_vec(fold1$obs, fold1$pred)
#' weighted_youden_index(fold1, obs, pred)
NULL

weighted_youden_index_impl <- function(
  truth,
  estimate,
  sensitivity_weight = 0.5
) {
  xtab <- table(truth, estimate)
  n <- nrow(xtab)
  indices <- 2:n

  specificity_value <- sum(sapply(indices, function(i) {
    ind_i <- indices[-i]
    cjk <- sum(xtab[ind_i, ind_i])
    cj <- sum(xtab[ind_i, ])
    cjk / cj
  }))
  specificity_value <- specificity_value / (n - 1)

  sensitivity_value <- sum(sapply(2:n, function(i) {
    cii <- xtab[i, i]
    ci <- sum(xtab[i, ])
    cii / ci
  }))
  sensitivity_value <- sensitivity_value / (n - 1)

  2 *
    (sensitivity_weight *
      sensitivity_value +
      (1 - sensitivity_weight) * specificity_value) -
    1
}

#' @export
#' @rdname weighted_youden_index
weighted_youden_index_vec <- function(
  truth,
  estimate,
  sensitivity_weight = 0.5,
  estimator = NULL,
  na_rm = TRUE,
  case_weights = NULL,
  event_level = "first",
  ...
) {
  estimator <- yardstick::finalize_estimator(truth, estimator)

  yardstick::check_class_metric(truth, estimate, case_weights, estimator)

  if (na_rm) {
    result <- yardstick::yardstick_remove_missing(truth, estimate, case_weights)

    truth <- result$truth
    estimate <- result$estimate
    case_weights <- result$case_weights
  } else if (yardstick::yardstick_any_missing(truth, estimate, case_weights)) {
    return(NA_real_)
  }

  weighted_youden_index_impl(
    truth,
    estimate,
    sensitivity_weight = sensitivity_weight
  )
}

weighted_youden_index <- function(data, ...) {
  UseMethod("weighted_youden_index")
}

#' @export
#' @rdname weighted_youden_index
weighted_youden_index <- yardstick::new_class_metric(
  weighted_youden_index,
  direction = "maximize"
)

#' @export
#' @rdname weighted_youden_index
weighted_youden_index.data.frame <- function(
  data,
  truth,
  estimate,
  sensitivity_weight = 0.5,
  estimator = NULL,
  na_rm = TRUE,
  case_weights = NULL,
  event_level = "first",
  ...
) {
  yardstick::class_metric_summarizer(
    name = "weighted_youden_index",
    fn = weighted_youden_index_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    estimator = estimator,
    na_rm = na_rm,
    event_level = event_level,
    case_weights = !!rlang::enquo(case_weights),
    fn_options = list(sensitivity_weight = sensitivity_weight)
  )
}
