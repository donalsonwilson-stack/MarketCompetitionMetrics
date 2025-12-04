# tests/testthat/test-boone.R
library(testthat)

test_that("Boone indicator matches expected per period", {
  df <- build_df()
  library(MarketCompetitionMetrics)
  res <- boone(df,
              cost_cols = c("Labor_cost","Capital_cost","Wage_cost"),
              profit_col = "Profit",
              period_col = "Period",
              plot = FALSE)
  for (p in names(expected_boone)) {
    val <- extract_period_value(res, p, key_candidates = c("Boone","boone","beta","beta_sum","value"))
    expect_equal(as.numeric(val), expected_boone[p], tolerance = 3e-3)
  }
})
