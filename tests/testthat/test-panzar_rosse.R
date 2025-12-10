library(testthat)

test_that("Panzar-Rosse H-statistic matches expected per period", {
  df <- build_df()
  res_panzar <- MarketCompetitionMetrics$panzar_rosse(
    df,
    revenue_col = "Revenue",
    input_cols = c("Labor_cost", "Capital_cost"),
    period_col = "Period",
    plot = FALSE
  )

  for (p in names(expected_panzar)) {
    val <- extract_period_value(res_panzar, p, key_candidates = c("H","h","H_stat","H_statistic"))
    expect_false(is.na(val), info = paste("Panzar-Rosse H is NA for period", p))
    expect_equal(as.numeric(val), as.numeric(expected_panzar[p]), tolerance = 1e-6)
  }
})
