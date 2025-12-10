library(testthat)

test_that("HHI matches expected per period", {
  df <- build_df()
  res_hhi <- MarketCompetitionMetrics$hhi(
    df,
    share_col = "Market_share",
    period_col = "Period",
    plot = FALSE
  )

  for (p in names(expected_hhi)) {
    val <- extract_period_value(res_hhi, p, key_candidates = c("HHI","hhi"))
    expect_false(is.na(val), info = paste("HHI is NA for period", p))
    expect_equal(as.numeric(val), as.numeric(expected_hhi[p]), tolerance = 1e-6)
  }
})
