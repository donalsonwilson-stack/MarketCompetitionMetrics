import pandas as pd
from market_competition_metrics import MarketCompetitionMetrics

# Load dataset
df = pd.read_csv("Synthetic_Market_Data.csv")

# Compute HHI per period
results_hhi = MarketCompetitionMetrics.hhi(
    df, share_col="Market_share", period_col="Period", plot=True
)
print(results_hhi)

# Compute Lerner Index
results_lerner = MarketCompetitionMetrics.lerner(
    df, firm_col="Firm", price_col="Price", cost_col="Marginal_cost",
    share_col="Market_share", period_col="Period", plot=True, stacked=True
)
print(results_lerner)

# Compute Panzar–Rosse H-statistic
results = MarketCompetitionMetrics.panzar_rosse(
    df, revenue_col="Revenue", input_cols=["Labor_cost", "Capital_cost"],
    period_col="Period", plot=True
)
print("H-statistic per period:", results)

# Compute Boone Indicator
results = MarketCompetitionMetrics.boone(
    df,
    cost_cols=["Labor_cost", "Capital_cost", "Wage_cost"],
    profit_col="Profit",
    period_col="Period",
    plot=True
)

# Show Boone indicator per period
for period, res in results.items():
    print(f"\nPeriod: {period}")
    print("Boone global:", res["Boone"])
    print("Coefficients (β_i):", res["coefficients"])
    print(res["summary"])
