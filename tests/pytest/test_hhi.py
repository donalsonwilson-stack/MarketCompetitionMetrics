# tests/pytest/test_hhi.py
import numpy as np
import pytest
from tests.pytest._helpers import _build_df, _extract_period_value, _expected

@pytest.mark.parametrize("period,expected", list(_expected["hhi"].items()))
def test_hhi(period, expected):
    df = _build_df()
    from market_competition_metrics import MarketCompetitionMetrics

    res = MarketCompetitionMetrics.hhi(df, share_col="Market_share", period_col="Period", plot=False)
    value = _extract_period_value(res, period, key_candidates=["HHI","hhi","HHI_t","value","hhi_t"])
    assert np.isclose(value, expected, rtol=1e-3, atol=1e-6), f"HHI mismatch for {period}: got {value}, expected {expected}"
