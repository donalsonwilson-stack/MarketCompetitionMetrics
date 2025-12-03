---
title: "An Open-Source Python and R Framework for Measuring Market Competition: Implementation of Boone, Panzar–Rosse, Lerner, and Herfindahl–Hirschman Indices"
authors:
  - name: Donalson Wilson
    orcid: 0009-0002-9430-981X
    affiliation: "1"
  - name: Abdellah Azmani
    orcid: 0000-0003-4975-3807
    affiliation: "1"
affiliations:
  - name: Abdelmalek Essaadi University, Faculty of Science and Technology of Tangier, Intelligent Automation and BioMed Genomics Laboratory (IABL), Morocco
    index: 1
date: "2025-12-05"
bibliography: paper.bib
---

# Summary

The Competitive analysis is a crucial component for firms operating in dynamic markets. Understanding market structure and the intensity of competition enables organizations to adjust strategies and make informed decisions. 
In this paper, we propose a dual open-source package for both Python and R environments that implements four of the most widely used competition measures in the literature: the Herfindahl–Hirschman Index (HHI), the Lerner Index, 
the Boone Indicator, and the Panzar–Rosse statistic. These packages provide researchers, practitioners, and students with a ready-to-use framework for conducting competition analysis. They are designed to handle both cross-sectional 
and time-series datasets and are adaptable to various sectors, including insurance, banking, and other competitive industries. The packages that we have introduced in this study are already available as open-source on GitHub (https://github.com/donalsonwilson-stack/MarketCompetitionMetrics) , 
and will also be released on CRAN (as MarketCompetitionMetrics.R), and PyPI (as market_competition_metrics). To the best of our knowledge, this work represents the first open-source effort to implement and unify these four competition metrics within both R and Python ecosystems.

# Statement of need

# Statement of need

In today’s digitalized economy, firms must continuously analyze the markets in which they operate in order to adapt strategies and make informed decisions. The regulators of the markets also require reliable tools to assess market structure and ensure proper regulation. Market competition can vary significantly, ranging from monopolistic and duopolistic settings to highly competitive environments.

Several economic indicators have been developed to measure the degree of competition within a market. Among the most widely used are the Herfindahl–Hirschman Index (HHI), introduced by Herfindahl and Hirschman (1945-1950) (@Herfindahl1950; @Hirschman2018), the Lerner index (@Lerner1934), the Boone indicator (@Boone2008; @BooneVanOursWiel2007) and the Panzar–Rosse H-statistic (@PanzarRosse1987; @RossePanzar1977). These metrics have been applied across different industries to evaluate competitive intensity. For instance, Abel and Marire (@AbelMarire2021) employed the Boone Indicator to measure competitiveness in Zimbabwe’s insurance sector between 2010 and 2017; Mpho and Witness (@MphoWitness2020) used both Boone and Panzar–Rosse indices to assess competition in South Africa’s banking industry; and Benazzi et al. (@BenazziRouiesi2017) analyzed the Moroccan banking sector using the Boone Indicator. Similarly, the HHI has frequently been used to evaluate market concentration, such as in Johan and Vania (@JohanVania2022), who investigated the concentration level of the financial technology industry.

Despite their extensive use in academic and policy research, these metrics are often computed using ad hoc scripts, combinations of statistical software, or partial code shared on platforms such as GitHub. This reflects a lack of standardized, accessible implementations in mainstream programming environments.

The objective of this article is to address this gap by introducing an open-source framework in both Python and R that implements the four principal competition measures: HHI, Lerner Index, Boone Indicator, and Panzar–Rosse statistic, within a unified package. This dual implementation is designed to support researchers, practitioners, and students in conducting robust and reproducible analyses of market competition.

This software is intended for economists, data scientists, regulators, and students who require a reproducible, transparent, and unified implementation of the four major market competition indicators. By consolidating these tools into a single open-source framework available in both Python and R, our contribution removes the dependence on fragmented scripts and facilitates consistent, replicable workflows for empirical research and policy analysis.


# Related Work

The Herfindahl–Hirschman Index (HHI) is one of the few competition measures sometimes available in standard econometric software, for instance through the hhi command in Stata or the IC2 package in R. An additional contribution in this space is the work of Philip D. Waggoner, who developed an R package computing the HHI index with integrated visualization via ggplot (@Waggoner2018). By contrast, other widely used indicators of competition are not natively supported in mainstream tools.
The Lerner Index is typically computed manually from price and marginal cost estimations, often relying on custom regressions in Stata, R, or Python. The Boone Indicator is even less standardized, most often estimated through ad hoc log-log OLS regressions, with implementation scattered across isolated R scripts or Stata modules. Similarly, the Panzar–Rosse H-statistic, though extensively applied in banking competition studies (e.g., (@AbelLeRoux2017; @BenazziRouiesi2017; @Molyneux1994; @ShafferSpierdijk2015)), is usually calculated using researcher-specific scripts rather than through an official package.
As a result, HHI is the only measure readily accessible in mainstream software, while the Lerner, Boone, and Panzar–Rosse indicators remain fragmented across custom, non-standard implementations. The contribution of this work is therefore to provide the first unified open-source Python and R packages that centralize all four indicators, delivering a consistent, ready-to-use framework for researchers and practitioners conducting market competition analysis.


# Mathematical foundations

## Herfindahl–Hirschman Index (HHI)

The Herfindahl–Hirschman Index (HHI) is primarily used to measure market concentration. Originally introduced in the late 1940s and 1950s by Herfindahl and Hirschman (@Herfindahl1950; @Hirschman2018), the HHI has become a key indicator in the study of market competition. It provides valuable insight into the degree of concentration and helps determine whether a firm operates in a perfectly competitive or imperfectly competitive environment. The index is parameterized by the number of firms operating in the market and is calculated as the sum of the squared market shares of all firms:

$$HHI_t = \sum_{i=1}^{n} S_{i,t}^2$$

Its value ranges between 0 (highly competitive market) and 10 000 (monopoly).

## Lerner Index

Developed by economist Abba P. Lerner in 1934 (@Lerner1934), the Lerner Index is used to quantify the market power of a firm i. This index measures a firm’s ability to set prices above marginal costs, thereby indicating the degree of market power it holds. The higher the index, the greater the firm’s dominance in the market. For a given firm i, the Lerner Index at time t is defined as:

$$L_{i,t} = \frac{P_{i,t} - MC_{i,t}}{P_{i,t}}$$

The market-wide index is computed as a market-share–weighted average.

## Panzar–Rosse H-statistic

The Panzar–Rosse model, introduced in 1977 (@PanzarRosse1987; @RossePanzar1977), is widely known through the H-statistic, which captures the static dimension of competition. The core idea is that firms adjust their pricing strategies in response to changes in input prices, depending on the behavior of their competitors. The H-statistic measures the degree of competition by quantifying how revenues react to variations in input prices. Formally, for firm i in period t, the model is estimated using the following log–log specification:


$$\ln R_{i,t} = \alpha + \sum_k \alpha_{k,t} \ln C_{k,i,t}$$

The H-statistic is defined as:

$$H_t = \sum_k \alpha_{k,t}$$

Its interpretation follows established competition theory:  
- \(H = 1\): perfect competition  
- \(0 < H < 1\): monopolistic competition  
- \(H < 0\): monopoly or collusive behavior

## Boone Indicator

Unlike the Panzar–Rosse model, which captures the static dimension of competition, the Boone Indicator (@Boone2000; @Boone2001; @Boone2004; @Boone2008; @BooneVanOursWiel2007) focuses on its dynamic aspect. It is based on the principle that more efficient firms (those with lower costs) achieve higher profitability in competitive markets. Boone’s approach measures the elasticity of profits with respect to marginal costs, formalized in the following log–log model:

$$\ln \pi_{i,t} = \lambda + \sum_k \beta_{k,t} \ln C_{k,i,t}$$

with:

$$\beta = \sum_k \beta_{k,t}$$

Negative values of $$\beta$$ indicate strong competition.

# Package description

The design of the packages supports both cross-sectional and time-series datasets. For cross-sectional data, the functions return the competition indicators along with their estimated parameters. For time-series data, the packages include a graphical option that allows users to visualize the evolution of the indices over time. For instance, when applying the Boone indicator, the packages return: The estimated Boone coefficients, the global Boone value for each period, and two graphical outputs illustrating the evolution of the indicator across time. The figure below presents the workflow of the python and R packages.

![Workflow of the Python and R packages](workflow.png)
**Fig. 1. Workflow of the Python and R packages.**

In addition to this unified workflow, the Python implementation relies on a set of widely used scientific libraries to ensure numerical stability and statistical rigor. NumPy is used for vectorized computations, pandas for data manipulation and grouping operations, matplotlib for producing time-series visualizations, and statsmodels for estimating the Boone and Panzar–Rosse regressions, including their associated econometric diagnostics.

Similarly, the R implementation depends on well-established packages from the tidyverse ecosystem. The dplyr package enables streamlined data manipulation and grouping operations, ggplot2 provides graphical visualization of the indices over time, and broom is used to extract tidy regression outputs for the Boone and Panzar–Rosse models. Together, these dependencies ensure that the R version delivers the same analytical consistency, interpretability, and reproducibility as its Python counterpart.

# Example

Below we provide a minimal usage example in both Python and R to illustrate how the proposed framework can be used to compute competition indicators with the provided dataset.

## Python example

```python
import pandas as pd
from market_competition_metrics import MarketCompetitionMetrics

# Load dataset
df = pd.read_csv("Synthetic_Market_Data.csv")

# Compute HHI per period
hhi_results = MarketCompetitionMetrics.hhi(
    df, share_col="Market_share", period_col="Period", plot=True
)

# Compute Lerner Index
lerner_results = MarketCompetitionMetrics.lerner(
    df,
    firm_col="Firm",
    price_col="Price",
    cost_col="Marginal_cost",
    share_col="Market_share",
    period_col="Period",
    plot=True
)

# Compute Panzar–Rosse H-statistic
pr_results = MarketCompetitionMetrics.panzar_rosse(
    df,
    revenue_col="Revenue",
    input_cols=["Labor_cost", "Capital_cost"],
    period_col="Period",
    plot=True
)

# Compute Boone Indicator
boone_results = MarketCompetitionMetrics.boone(
    df,
    cost_cols=["Labor_cost", "Capital_cost", "Wage_cost"],
    profit_col="Profit",
    period_col="Period",
    plot=True
)

## R example
library(MarketCompetitionMetrics)

# Load dataset
data <- read.csv("Synthetic_Market_Data.csv")

# Compute HHI per period
results_hhi <- hhi(data, share_col="Market_share", period_col="Period", plot=TRUE)

# Compute Lerner Index
results_lerner <- lerner(
  data,
  firm_col="Firm",
  price_col="Price",
  cost_col="Marginal_cost",
  share_col="Market_share",
  period_col="Period",
  plot=TRUE
)

# Compute Panzar–Rosse H-statistic
results_pr <- panzar_rosse(
  data,
  revenue_col = "Revenue",
  input_cols = c("Labor_cost", "Capital_cost"),
  period_col = "Period",
  plot = TRUE
)

# Compute Boone Indicator
results_boone <- boone(
  data,
  cost_cols = c("Labor_cost", "Capital_cost", "Wage_cost"),
  profit_col = "Profit",
  period_col = "Period",
  plot = TRUE
)

```
# Acknowledgments

This work was supported by the Moroccan Ministry of Higher Education, Scientific Research and Innovation, the Digital Development Agency (DDA), and the CNRST under the Smart DLSP Project – AL KHAWARIZMI Program.

# Conflicts of interest

The authors declare that there are no conflicts of interest associated with this manuscript.



