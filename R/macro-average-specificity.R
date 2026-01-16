#' Macro Average Specificity
#'
#' This function computes the macro-average specificity for a multi-class prediction model.
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
#' @returns A scalar storing the value of the macro-average specificity score.
#'
#' @name macro_average_specificity
#' @examples
#' fold1 <- subset(yardstick::hpc_cv, Resample == "Fold01")
#' macro_average_specificity_vec(fold1$obs, fold1$pred)
#' macro_average_specificity(fold1, obs, pred)
NULL

macro_average_specificity_impl <- function(truth, estimate) {
  xtab <- table(truth, estimate) # confusion matrix
  n <- nrow(xtab)
  indices <- 2:n
  acc <- sum(sapply(indices, function(i) {
    ind_i <- indices[-i]
    cjk <- sum(xtab[ind_i, ind_i])
    cj <- sum(xtab[ind_i, ])
    cjk / cj
  }))
  acc / (n - 1)
}

#' @export
#' @rdname macro_average_specificity
macro_average_specificity_vec <- function(
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

  macro_average_specificity_impl(truth, estimate)
}

macro_average_specificity <- function(data, ...) {
  UseMethod("macro_average_specificity")
}

#' @export
#' @rdname macro_average_specificity
macro_average_specificity <- yardstick::new_class_metric(
  macro_average_specificity,
  direction = "maximize"
)

#' @export
#' @rdname macro_average_specificity
macro_average_specificity.data.frame <- function(
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
    name = "macro_average_specificity",
    fn = macro_average_specificity_vec,
    data = data,
    truth = !!rlang::enquo(truth),
    estimate = !!rlang::enquo(estimate),
    estimator = estimator,
    na_rm = na_rm,
    case_weights = !!rlang::enquo(case_weights),
    event_level = event_level
  )
}
