# tests/pytest/_helpers.py
import numpy as np
import pandas as pd

def _build_df():
    data = [
        ("2025-01-01","Enter_A",182000,17000,40000,33000,32000,54.065853,46.514387,23.790850,182000),
        ("2025-01-01","Enter_B",131000,45000,59000,38000,12000,51.440915,45.946205,17.124183,131000),
        ("2025-01-01","Enter_C",172000,39000,57000,16000,37000,62.838316,38.469592,22.483660,172000),
        ("2025-01-01","Enter_D",94000,31000,44000,41000,36000,77.990268,32.006169,12.287582,94000),
        ("2025-01-01","Enter_E",186000,25000,34000,17000,14000,92.528140,39.809936,24.313725,186000),

        ("2025-02-01","Enter_A",118000,23000,28000,40000,30000,66.162568,37.510972,19.504132,118000),
        ("2025-02-01","Enter_B",97000,16000,27000,49000,23000,77.374243,37.722116,16.033058,97000),
        ("2025-02-01","Enter_C",83000,13000,21000,20000,31000,88.269720,39.847145,13.719008,83000),
        ("2025-02-01","Enter_D",168000,27000,45000,48000,19000,112.637915,76.419707,27.768595,168000),
        ("2025-02-01","Enter_E",139000,24000,27000,28000,32000,86.458398,79.460373,22.975207,139000),

        ("2025-03-01","Enter_A",164000,33000,45000,39000,37000,92.492397,45.867855,19.025522,164000),
        ("2025-03-01","Enter_B",159000,38000,34000,15000,34000,119.082086,94.931951,18.445476,159000),
        ("2025-03-01","Enter_C",188000,17000,43000,25000,28000,99.480014,77.006392,21.809745,188000),
        ("2025-03-01","Enter_D",161000,42000,24000,42000,16000,109.502700,63.485289,18.677494,161000),
        ("2025-03-01","Enter_E",190000,42000,42000,38000,14000,101.072432,72.124973,22.041763,190000),
    ]
    cols = ["Period","Firm","Revenue","Profit","Labor_cost","Capital_cost","Wage_cost","Price","Marginal_cost","Market_share","Income"]
    df = pd.DataFrame(data, columns=cols)
    return df

# Expected reference values
_expected_hhi = {
    "2025-01-01": 2106.899056,
    "2025-02-01": 2124.636295,
    "2025-03-01": 2012.559149
}

_expected_lerner = {
    "2025-01-01": 34.968959,
    "2025-02-01": 34.977133,
    "2025-03-01": 32.420292
}

_expected_panzar_H = {
    "2025-01-01": -0.7163348570892567,
    "2025-02-01": 2.3994264326679975,
    "2025-03-01": 0.08148894479552721
}

_expected_boone = {
    "2025-01-01": 1.0392723995926665,
    "2025-02-01": 3.4483401612826894,
    "2025-03-01": -0.6410995038664125
}

def _extract_period_value(result, period, key_candidates):
    """
    Try to extract a numeric value for a given period from `result`.
    Accept dict, DataFrame, Series, float, list, nested dicts.
    """
    import pandas as pd
    import numpy as np

    # If result is a dict with period keys
    if isinstance(result, dict):
        # direct period key
        if period in result:
            v = result[period]
            if isinstance(v, (int, float, np.floating)):
                return float(v)
            if isinstance(v, dict):
                for kc in key_candidates:
                    if kc in v:
                        return float(v[kc])
                # try to find first numeric value
                for vv in v.values():
                    if isinstance(vv, (int, float, np.floating)):
                        return float(vv)
        # keys as strings
        for k in result:
            if str(k).startswith(str(period)):
                v = result[k]
                if isinstance(v, (int, float, np.floating)):
                    return float(v)
                if isinstance(v, dict):
                    for kc in key_candidates:
                        if kc in v:
                            return float(v[kc])
                    for vv in v.values():
                        if isinstance(vv, (int, float, np.floating)):
                            return float(vv)
        # maybe top-level mapping metric -> pd.Series/dict
        for kc in key_candidates:
            if kc in result:
                cand = result[kc]
                if isinstance(cand, (dict, pd.Series)):
                    # try direct index
                    if period in cand:
                        return float(cand[period])
                    # try string key
                    if str(period) in cand:
                        return float(cand[str(period)])

    # DataFrame
    if isinstance(result, pd.DataFrame):
        # try columns keys
        for col in key_candidates:
            if col in result.columns:
                if 'Period' in result.columns:
                    row = result[result['Period'] == period]
                    if not row.empty:
                        return float(row.iloc[0][col])
                try:
                    return float(result.loc[period, col])
                except Exception:
                    pass
        # fallback: if single numeric column
        numeric_cols = [c for c in result.columns if np.issubdtype(result[c].dtype, np.number)]
        if len(numeric_cols) == 1:
            col = numeric_cols[0]
            if 'Period' in result.columns:
                row = result[result['Period'] == period]
                if not row.empty:
                    return float(row.iloc[0][col])
            # else first value
            return float(result.iloc[0, result.columns.get_loc(col)])

    # Series
    if isinstance(result, pd.Series):
        if period in result.index:
            return float(result.loc[period])
        if str(period) in result.index:
            return float(result.loc[str(period)])
        if result.size == 1:
            return float(result.iloc[0])

    # numeric
    if isinstance(result, (int, float, np.floating)):
        return float(result)

    # list/tuple
    if isinstance(result, (list, tuple)):
        for item in result:
            if isinstance(item, (int, float, np.floating)):
                return float(item)

    raise ValueError("Could not extract numeric value from result for period=%s" % str(period))

# expose expected dicts for importing tests
_expected = {
    "hhi": _expected_hhi,
    "lerner": _expected_lerner,
    "panzar": _expected_panzar_H,
    "boone": _expected_boone
}
