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
Once the user installs the package from GitHub, it becomes available in all of their Python environments, such as Jupyter Notebook, VS Code, the terminal (Python REPL), Spyder, PyCharm, etc.
They can then directly run the usage examples provided below.

### In R

From CRAN *(coming soon)*:
```bash
install.packages("MarketCompetitionMetrics")
```

From GitHub:
```bash
devtools::install_github("donalsonwilson-stack/MarketCompetitionMetrics")
```
Similarly, once the user installs the R package (either from GitHub or, later, from CRAN), it becomes available in their R environment, including RStudio, the R console, or any R script execution environment.
They can then immediately run the usage examples provided below.

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
## General Local Testing Guide (Windows, macOS, Linux) for Reviewers
### Python package
Reviewers can test the Python implementation of MarketCompetitionMetrics by cloning the repository locally.
The steps below are platform-independent and work on Windows, macOS, and Linux.

1) Clone the repository
```bash
git clone https://github.com/donalsonwilson-stack/MarketCompetitionMetrics.git
cd MarketCompetitionMetrics
```
2) Create a dedicated virtual environment (Python 3.8+)
```bash
python -m venv .venv
```
3) Activate the environment
```bash
# Windows:
.venv\Scripts\activate.bat
# macOS/Linux:
source .venv/bin/activate
```
4) Install the package in development mode
```bash
pip install -e .
```
5) Run the full test suite
```bash
pytest -q
```
This workflow ensures clean isolation of dependencies and allows reviewers to reproduce results reliably across different operating systems. 
The included test suite validates all core competition indicators (HHI, Lerner, Boone, and Panzar–Rosse).

### R package
Reviewers can test the R implementation of MarketCompetitionMetrics by cloning the repository and running the standard development workflow.
The procedure below works on Windows, macOS, and Linux.
1) Clone the repository
```bash
git clone https://github.com/donalsonwilson-stack/MarketCompetitionMetrics.git
cd MarketCompetitionMetrics
```
2) Open the project in RStudio
   
Open RStudio

Go to File → Open Project…

Select the folder MarketCompetitionMetrics/
(This ensures that RStudio uses the correct working directory and project environment.)

3) Install development tools (first time only)
```bash
install.packages("remotes")
install.packages("pkgload")
install.packages("testthat")
```
4) Load the package from source
```bash
pkgload::load_all()   # loads the package in development mode
```

5) Run the full test suite
```bash
testthat::test_dir("tests/testthat")
```
You should observe: [ FAIL 0 | WARN 0 | SKIP 0 | PASS 24 ]

6) Load and use the package
```bash
# Example:
library(MarketCompetitionMetrics)
data <- read.csv("inst/extdata/Synthetic_Market_Data.csv")

# Example:
# Compute HHI per period
results_hhi <- hhi(data, share_col="Market_share", period_col="Period", plot=TRUE)
print(results_hhi)
```
This workflow ensures that reviewers can test the R version in a clean environment while reproducing results consistently across operating systems.
The included test suite validates all four competition indicators (HHI, Lerner, Boone, and Panzar–Rosse).


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
