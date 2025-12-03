# MarketCompetitionMetrics

**A Dual Python & R Package for Measuring Market Competition**

**Authors:** Donalson Wilson & Abdellah Azmani  
**Affiliation:** Abdelmalek Essaâdi University – Intelligent Automation and Bio Med Genomics Laboratory (IABL), Morocco  

---

## 🔎 Overview

The **MarketCompetitionMetrics** package provides an open-source implementation of four widely used market competition indicators:

- **Herfindahl–Hirschman Index (HHI)**  
- **Lerner Index**  
- **Boone Indicator**  
- **Panzar–Rosse H-statistic**  

It is available in both **Python** and **R**, ensuring consistency across programming environments and facilitating adoption by researchers, students, and practitioners in economics, finance, and industrial organization.  

The package supports **cross-sectional** and **time-series** datasets, offering both numerical results and graphical visualizations of competition indicators over time.  

---

## ⚙️ Installation

### In Python  
From PyPI *(coming soon)*:
```bash
pip install market_competition_metrics
```
From GitHub:
```bash
pip install git+https://github.com/donalsonwilson-stack/MarketCompetitionMetrics.git
```
### In R

From CRAN *(coming soon)*:
```bash
install.packages("MarketCompetitionMetrics")
```

From GitHub:
```bash
devtools::install_github("donalsonwilson-stack/MarketCompetitionMetrics")
```
---
## 📘 Usage
### Python Example
```bash
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
```

### R Example
```bash
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
```
## Features

✔️ Handles both cross-sectional and time-series datasets

✔️ Provides econometric diagnostics (R², Adjusted R², F-statistic, p-values, AIC, BIC, etc.) via regression models

✔️ Visualizes the evolution of competition indicators over time

✔️ Ensures consistency between Python and R implementations

✔️ Open-source, adaptable to multiple markets (banking, insurance, manufacturing, etc.)

---

## Authors & Acknowledgments

- **Donalson Wilson**, PhD Candidate in Data Science & AI

- **Abdellah Azmani**, Professor & Researcher

This research is supported by the Ministry of Higher Education, Scientific Research, and Innovation, the Digital Development Agency (DDA), and the National Center for Scientific and Technical Research (CNRST) of Morocco, under the Smart DLSP Project – AL KHAWARIZMI AI-Program.

---

## 📜 License

This project is licensed under the MIT License – free to use, modify, and distribute with attribution.

---
## 📚 Citation

If you use this package, please cite:

Wilson, D. & Azmani, A. (2025). MarketCompetitionMetrics: An Open-Source Python and R Framework for Measuring Market Competition: Implementation of Boone, Panzar-Rosse, Lerner, and Herfindahl-Hirschman Indices.
