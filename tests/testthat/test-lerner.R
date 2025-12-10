library(testthat)

test_that("Lerner index matches expected per period", {
  df <- build_df()
  res_lerner <- MarketCompetitionMetrics$lerner(
    df,
    firm_col = "Firm",
    price_col = "Price",
    cost_col = "Marginal_cost",
    share_col = "Market_share",
    period_col = "Period",
    plot = FALSE
  )

  for (p in names(expected_lerner)) {
    val <- extract_period_value(res_lerner, p, key_candidates = c("market","Market","Lerner","lerner"))
    expect_false(is.na(val), info = paste("Lerner is NA for period", p))
    expect_equal(as.numeric(val), as.numeric(expected_lerner[p]), tolerance = 1e-6)
  }
})


