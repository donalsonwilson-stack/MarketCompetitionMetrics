#!/usr/bin/env python
# coding: utf-8

# In[1]:


# ==============================================================
# market_competition_metrics.py
# A Python package for computing market competition indicators:
#   - Herfindahl-Hirschman Index (HHI)
#   - Lerner Index
#   - Boone Indicator
#   - Panzar-Rosse H-statistic
#
# Authors: Donalson WILSON and Abdellah AZMANI
# Affiliation : Abdelmalek Essaadi University, Faculty of Science and Technology of Tangier, 
#               Intelligent Automation and Bio Med Genomics Laboratory (IABL), Morocco.
# Date: 2025
# ==============================================================

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import statsmodels.api as sm


class MarketCompetitionMetrics:
    """
    A class implementing mathematical-economic models to measure 
    market competition.
    """
    
    @staticmethod 
    def hhi(data, share_col, period_col=None, plot=False):
        """
        Compute Herfindahl-Hirschman Index (HHI).
        
        Parameters:
            data (pd.DataFrame): dataset
            share_col (str): column with market shares
            period_col (str): optional column name for period (day, month, year)
            plot (bool): whether to plot HHI over time if period_col is provided
            
        Returns:
            float or dict: HHI for all firms (if no period) or per period
        """
        if period_col:
            hhi_values = data.groupby(period_col)[share_col].apply(lambda x: np.sum(x**2)).to_dict()
            
            # Visualization 
            if plot:
                plt.figure(figsize=(8,5))
                plt.plot(list(hhi_values.keys()), list(hhi_values.values()), marker="o", color="blue")
                plt.title("Evolution of the HHI Index over Time")
                plt.xlabel("Period")
                plt.ylabel("HHI")
                plt.grid(True, linestyle="--", alpha=0.6)
                plt.show()
            
            return hhi_values
        else:
            return np.sum(data[share_col] ** 2)
        
        
    @staticmethod
    def lerner(data, firm_col, price_col, cost_col, share_col, period_col=None, plot=False, stacked=False):
        """
        Compute Lerner Index (market + firm contributions) per period.

        Parameters:
            data (pd.DataFrame): dataset
            firm_col (str): column with firm names
            price_col (str): column with prices
            cost_col (str): column with marginal costs
            share_col (str): column with market shares (already computed)
            period_col (str): optional column for periods (month, year...)
            plot (bool): if True, plot market Lerner index over time
            stacked (bool): if True, plot stacked bar chart of firm contributions

        Returns:
            dict: {period: market Lerner index}
        """
        def _compute_lerner(df):
            df = df.copy()
            df["Lerner_i"] = (df[price_col] - df[cost_col]) / df[price_col]
            L_market = np.sum(df[share_col] * df["Lerner_i"])
            df["contribution"] = df[share_col] * df["Lerner_i"]
            return {"market": L_market, "contributions": df[[firm_col, "contribution"]]}

        if period_col:
            results = {period: _compute_lerner(df) for period, df in data.groupby(period_col)}

            # Extract market Lerner values for dictionary output
            market_dict = {period: res["market"] for period, res in results.items()}

            # Line plot of LM over time
            if plot:
                periods = list(market_dict.keys())
                market_values = list(market_dict.values())

                plt.figure(figsize=(8, 5))
                plt.plot(periods, market_values, marker="o", color="green")
                plt.title("Market Lerner Index Over Time")
                plt.xlabel("Period")
                plt.ylabel("Lerner Index (LM)")
                plt.grid(True, linestyle="--", alpha=0.6)
                plt.show()

            # Stacked contributions
            if stacked:
                firms = sorted(data[firm_col].unique())
                contributions = {firm: [] for firm in firms}
                periods = list(results.keys())

                for period, res in results.items():
                    df_contrib = res["contributions"].set_index(firm_col)
                    for firm in firms:
                        contributions[firm].append(df_contrib.loc[firm, "contribution"] if firm in df_contrib.index else 0)

                plt.figure(figsize=(12, 6))
                bottom = np.zeros(len(periods))
                for firm in firms:
                    plt.bar(periods, contributions[firm], bottom=bottom, label=firm)
                    bottom += contributions[firm]
                plt.title("Firm Contributions to Market Lerner Index")
                plt.xlabel("Period")
                plt.ylabel("Contribution to LM")
                plt.legend(title="Firms", bbox_to_anchor=(0.5, -0.15), loc="upper center", ncol=5)  # move legend below
                plt.tight_layout()
                plt.show()

            return market_dict

        else:
            res = _compute_lerner(data)
            return {"overall_market": res["market"]}


    @staticmethod
    def panzar_rosse(data, revenue_col, input_cols, period_col=None, plot=False):
        """
        Estimate Panzar-Rosse H-statistic.

        Parameters:
            data (pd.DataFrame): dataset
            revenue_col (str): column with revenues
            input_cols (list): list of column names for input prices
            period_col (str): optional column for periods (month, year, etc.)
            plot (bool): if True, plot H-statistic over time

        Returns:
            dict:
                - If no period_col: {"overall": H-statistic, "summary": model.summary()}
                - If period_col: {period: {"H": value, "summary": model.summary()}}
        """

        def _compute_pr(df):
            X = sm.add_constant(np.log(df[input_cols]))
            y = np.log(df[revenue_col])
            model = sm.OLS(y, X).fit()
            H_stat = np.sum(model.params[1:])  # exclude constant
            return {"H": H_stat, "summary": model.summary()}

        # Case: compute per period
        if period_col:
            results = {}
            H_values = []

            for period, df in data.groupby(period_col):
                res = _compute_pr(df)
                results[period] = res
                H_values.append((period, res["H"]))

            # Plot if requested
            if plot:
                plt.figure(figsize=(8, 5))
                plt.plot(
                    [p for p, _ in H_values],
                    [h for _, h in H_values],
                    marker="o",
                    linestyle="-",
                    color="blue"
                )
                plt.title("Evolution of Panzar-Rosse H-statistic Over Time")
                plt.xlabel("Period")
                plt.ylabel("H-statistic")
                plt.grid(True, linestyle="--", alpha=0.6)
                plt.show()

            return results

        # Case: overall dataset (no period)
        else:
            return _compute_pr(data) 
     
    
    @staticmethod
    def boone(data, cost_cols, profit_col, period_col=None, plot=False):
        """
        Estimate Boone indicator using log-log regression with one or multiple cost variables.

        Parameters:
            data (pd.DataFrame): dataset
            cost_cols (list): list of columns with cost variables (labour, capital, borrowed funds, etc.)
            profit_col (str): column with profits
            period_col (str): optional column for periods (month, year, etc.)
            plot (bool): if True, plot Boone coefficient over time

        Returns:
            dict:
                - If no period_col:
                    {"Boone": β_global, "coefficients": dict of β_i, "summary": model.summary()}
                - If period_col:
                    {period: {"Boone": β_global, "coefficients": dict of β_i, "summary": model.summary()}}
        """

        def _compute_boone(df):
            X = sm.add_constant(np.log(df[cost_cols]))
            y = np.log(df[profit_col])
            model = sm.OLS(y, X).fit()

            betas = model.params[1:]  # exclude constant
            betas_dict = {col: betas[i] for i, col in enumerate(cost_cols)}  # label coefficients
            beta_global = np.sum(betas)  # Boone indicator = sum of betas

            return {
                "Boone": beta_global,
                "coefficients": betas_dict,
                "summary": model.summary()
            }

        # Case: per period
        if period_col:
            results = {}
            boone_values = []

            for period, df in data.groupby(period_col):
                res = _compute_boone(df)
                results[period] = res
                boone_values.append((period, res["Boone"]))

            # Plot Boone evolution if requested
            if plot:
                plt.figure(figsize=(8, 5))
                plt.plot(
                    [p for p, _ in boone_values],
                    [b for _, b in boone_values],
                    marker="o",
                    linestyle="-",
                    color="green"
                )
                plt.title("Evolution of Boone Indicator (β) Over Time")
                plt.xlabel("Period")
                plt.ylabel("Boone Indicator (β)")
                plt.grid(True, linestyle="--", alpha=0.6)
                plt.show()

            return results

        # Case: overall dataset
        else:
            return _compute_boone(data)

