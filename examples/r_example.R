library(MarketCompetitionMetrics)

# Load dataset
data <- read.csv("Synthetic_Market_Data.csv")

# Compute HHI per period
results_hhi <- hhi(data, share_col="Market_share", period_col="Period", plot=TRUE)
print(results_hhi)

# Compute Lerner Index
results_lerner <- lerner(data, firm_col="Firm", price_col="Price",
                         cost_col="Marginal_cost", share_col="Market_share",
                         period_col="Period", plot=TRUE)
print(results_lerner)

# Compute Panzar–Rosse
results_pr <- panzar_rosse(
  data,
  revenue_col = "Revenue",
  input_cols = c("Labor_cost", "Capital_cost", "Wage_cost"),
  period_col = "Period",
  plot = TRUE
)
print(results_pr)

# Compute Boone Indicator
results_boone <- boone(
  data,
  cost_cols = c("Labor_cost", "Capital_cost", "Wage_cost"),
  profit_col = "Profit",
  period_col = "Period",
  plot = TRUE
)
print(results_boone)
