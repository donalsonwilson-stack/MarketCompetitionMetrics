# tests/pytest/test_boone.py
import numpy as np
import pytest
from tests.pytest._helpers import _build_df, _extract_period_value, _expected

@pytest.mark.parametrize("period,expected", list(_expected["boone"].items()))
def test_boone(period, expected):
    df = _build_df()
    from market_competition_metrics import MarketCompetitionMetrics

    res = MarketCompetitionMetrics.boone(
        df,
        cost_cols=["Labor_cost", "Capital_cost", "Wage_cost"],
        profit_col="Profit",
        period_col="Period",
        plot=False
    )

    value = _extract_period_value(res, period, key_candidates=["Boone","boone","beta","beta_sum","value"])
    assert np.isclose(value, expected, rtol=3e-3, atol=1e-6), f"Boone mismatch for {period}: got {value}, expected {expected}"
