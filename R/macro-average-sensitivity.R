#' Macro Average Sensitivity
#'
#' This function computes the macro-average sensitivity for a multi-class prediction model.
#' It assumes that the *negative* class is the first one.
#'
#' @param data Either a data.frame containing the columns specified by the truth and estimate
#' arguments, or a table/matrix where the true class results should be in the columns of the table.
#' @param truth The column identifier for the true class results (that is a factor).
#' @param estimate The column identifier for the predicted class results (that is also factor).
#' @param estimator One of: "binary", "macro", "macro_weighted", or "micro" to specify the type of averaging to be done.
#' @param na_rm A logical value indicating whether NA values should be stripped before the computation proceeds.
#' @param case_weights The optional column identifier for case weights.
#' @param event_level A single string. Either "first" or "second" to specify which level of truth to consider as the "event".
#' This argument is only applicable when estimator = "binary".
#' @param ... Currently unused.
#'
#' @returns A scalar storing the value of the macro-average sensitivity score.
#'
#' @name macro_average_sensitivity
#' @examples
#' fold1 <- subset(yardstick::hpc_cv, Resample == "Fold01")
#' macro_average_sensitivity_vec(fold1$obs, fold1$pred)
#' macro_average_sensitivity(fold1, obs, pred)
NULL

macro_average_sensitivity_impl <- function(truth, estimate) {
  xtab <- table(truth, estimate)
  n <- nrow(xtab)
  acc <- sum(sapply(2:n, function(i) {
    cii <- xtab[i, i]
    ci <- sum(xtab[i, ])
    cii / ci
  }))
  acc / (n - 1)
}

#' @export
#' @rdname macro_average_sensitivity
macro_average_sensitivity_vec <- function(
  truth,
  estimate,
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

  macro_average_sensitivity_impl(truth, estimate)
}

macro_average_sensitivity <- function(data, ...) {
  UseMethod("macro_average_sensitivity")
}

#' @export
#' @rdname macro_average_sensitivity
macro_average_sensitivity <- yardstick::new_class_metric(
  macro_average_sensitivity,
  direction = "maximize"
)

#' @export
#' @rdname macro_average_sensitivity
macro_average_sensitivity.data.frame <- function(
  data,
  truth,
  estimate,
  estimator = NULL,
  na_rm = TRUE,
  case_weights = NULL,
  event_level = "first",
  ...
) {
  yardstick::class_metric_summarizer(
    name = "macro_average_sensitivity",
    fn = macro_average_sensitivity_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    estimator = estimator,
    na_rm = na_rm,
    event_level = event_level,
    case_weights = !!rlang::enquo(case_weights)
  )
}
