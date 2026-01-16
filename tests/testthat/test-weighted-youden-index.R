test_that("weighted_youden_index() works", {
  fold1 <- subset(yardstick::hpc_cv, Resample == "Fold01")
  expect_equal(
    round(weighted_youden_index_vec(fold1$obs, fold1$pred), 2),
    0.13
  )
  out <- weighted_youden_index(fold1, obs, pred)
  expect_is(out, "tbl_df")
  expect_equal(ncol(out), 3)
  fold1$obs[1] <- NA
  expect_equal(
    round(weighted_youden_index_vec(fold1$obs, fold1$pred), 2),
    0.13
  )
  expect_true(is.na(weighted_youden_index_vec(
    fold1$obs,
    fold1$pred,
    na_rm = FALSE
  )))
})
