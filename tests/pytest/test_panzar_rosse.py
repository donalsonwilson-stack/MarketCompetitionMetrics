# tests/pytest/test_panzar_rosse.py
import numpy as np
import pytest
from tests.pytest._helpers import _build_df, _extract_period_value, _expected

@pytest.mark.parametrize("period,expected", list(_expected["panzar"].items()))
def test_panzar_rosse(period, expected):
    df = _build_df()
    from market_competition_metrics import MarketCompetitionMetrics

    res = MarketCompetitionMetrics.panzar_rosse(
        df,
        revenue_col="Revenue",
        input_cols=["Labor_cost", "Capital_cost"],
        period_col="Period",
        plot=False
    )

    value = _extract_period_value(res, period, key_candidates=["H","H_t","h","value"])
    assert np.isclose(value, expected, rtol=2e-3, atol=1e-6), f"Panzar-Rosse H mismatch for {period}: got {value}, expected {expected}"
