# tests/pytest/test_lerner.py
import numpy as np
import pytest
from tests.pytest._helpers import _build_df, _extract_period_value, _expected

@pytest.mark.parametrize("period,expected", list(_expected["lerner"].items()))
def test_lerner(period, expected):
    df = _build_df()
    from market_competition_metrics import MarketCompetitionMetrics

    res = MarketCompetitionMetrics.lerner(
        df,
        firm_col="Firm",
        price_col="Price",
        cost_col="Marginal_cost",
        share_col="Market_share",
        period_col="Period",
        plot=False,
        stacked=False
    )

    value = _extract_period_value(res, period, key_candidates=["Lerner","lerner","L","L_t","value"])
    assert np.isclose(value, expected, rtol=2e-3, atol=1e-6), f"Lerner mismatch for {period}: got {value}, expected {expected}"
