# tests/testthat/test-lerner.R
library(testthat)

test_that("Lerner index matches expected per period", {
  df <- build_df()
  library(MarketCompetitionMetrics)
  res <- lerner(df,
                firm_col = "Firm",
                price_col = "Price",
                cost_col = "Marginal_cost",
                share_col = "Market_share",
                period_col = "Period",
                plot = FALSE)
  for (p in names(expected_lerner)) {
    val <- extract_period_value(res, p, key_candidates = c("Lerner","lerner","L","value"))
    expect_equal(as.numeric(val), expected_lerner[p], tolerance = 2e-3)
  }
})
