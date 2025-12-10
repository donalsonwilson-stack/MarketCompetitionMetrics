library(testthat)

test_that("Boone indicator matches expected per period", {
  df <- build_df()
  res_boone <- MarketCompetitionMetrics$boone(
    df,
    cost_cols = c("Labor_cost","Capital_cost","Wage_cost"),
    profit_col = "Profit",
    period_col = "Period",
    plot = FALSE
  )

  for (p in names(expected_boone)) {
    val <- extract_period_value(res_boone, p, key_candidates = c("Boone","boone","beta","value"))
    expect_false(is.na(val), info = paste("Boone is NA for period", p))
    expect_equal(as.numeric(val), as.numeric(expected_boone[p]), tolerance = 1e-6)
  }
})

