# tests/testthat/test-panzar_rosse.R
library(testthat)

test_that("Panzar-Rosse H-statistic matches expected per period", {
  df <- build_df()
  library(MarketCompetitionMetrics)
  res <- panzar_rosse(df,
                     revenue_col = "Revenue",
                     input_cols = c("Labor_cost","Capital_cost"),
                     period_col = "Period",
                     plot = FALSE)
  for (p in names(expected_panzar)) {
    val <- extract_period_value(res, p, key_candidates = c("H","H_t","h","value"))
    expect_equal(as.numeric(val), expected_panzar[p], tolerance = 2e-3)
  }
})
