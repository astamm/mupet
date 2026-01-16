test_that("macro_average_sensitivity() works", {
  fold1 <- subset(yardstick::hpc_cv, Resample == "Fold01")
  expect_equal(
    round(macro_average_sensitivity_vec(fold1$obs, fold1$pred), 2),
    0.42
  )
  out <- macro_average_sensitivity(fold1, obs, pred)
  expect_is(out, "tbl_df")
  expect_equal(ncol(out), 3)
})
