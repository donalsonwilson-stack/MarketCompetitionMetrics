# tests/testthat/test-hhi.R
library(testthat)
# helper.R is auto-sourced by testthat when named helper*.R

test_that("HHI matches expected per period", {
  df <- build_df()
  # load package (in test env, package should be available)
  library(MarketCompetitionMetrics)
  res <- hhi(df, share_col = "Market_share", period_col = "Period", plot = FALSE)
  for (p in names(expected_hhi)) {
    val <- extract_period_value(res, p, key_candidates = c("HHI","hhi","HHI_t","value"))
    expect_equal(as.numeric(val), expected_hhi[p], tolerance = 1e-3)
  }
})
