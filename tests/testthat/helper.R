# tests/testthat/helper.R
library(testthat)

# Reconstruct the exact dataset used in Python tests
build_df <- function() {
  data <- list(
    Period = c(
      rep("2025-01-01", 5),
      rep("2025-02-01", 5),
      rep("2025-03-01", 5)
    ),
    Firm = c("Enter_A","Enter_B","Enter_C","Enter_D","Enter_E",
             "Enter_A","Enter_B","Enter_C","Enter_D","Enter_E",
             "Enter_A","Enter_B","Enter_C","Enter_D","Enter_E"),
    Revenue = c(182000,131000,172000,94000,186000,
                118000,97000,83000,168000,139000,
                164000,159000,188000,161000,190000),
    Profit = c(17000,45000,39000,31000,25000,
               23000,16000,13000,27000,24000,
               33000,38000,17000,42000,42000),
    Labor_cost = c(40000,59000,57000,44000,34000,
                   28000,27000,21000,45000,27000,
                   45000,34000,43000,24000,42000),
    Capital_cost = c(33000,38000,16000,41000,17000,
                     40000,49000,20000,48000,28000,
                     39000,15000,25000,42000,38000),
    Wage_cost = c(32000,12000,37000,36000,14000,
                  30000,23000,31000,19000,32000,
                  37000,34000,28000,16000,14000),
    Price = c(54.065853,51.440915,62.838316,77.990268,92.528140,
              66.162568,77.374243,88.269720,112.637915,86.458398,
              92.492397,119.082086,99.480014,109.502700,101.072432),
    Marginal_cost = c(46.514387,45.946205,38.469592,32.006169,39.809936,
                      37.510972,37.722116,39.847145,76.419707,79.460373,
                      45.867855,94.931951,77.006392,63.485289,72.124973),
    Market_share = c(23.790850,17.124183,22.483660,12.287582,24.313725,
                     19.504132,16.033058,13.719008,27.768595,22.975207,
                     19.025522,18.445476,21.809745,18.677494,22.041763),
    Income = c(182000,131000,172000,94000,186000,
               118000,97000,83000,168000,139000,
               164000,159000,188000,161000,190000)
  )
  df <- as.data.frame(data, stringsAsFactors = FALSE)
  # ensure numeric columns are numeric
  num_cols <- c("Revenue","Profit","Labor_cost","Capital_cost","Wage_cost","Price","Marginal_cost","Market_share","Income")
  df[num_cols] <- lapply(df[num_cols], as.numeric)
  return(df)
}

# Expected values (same as Python tests)
expected_hhi <- c(
  "2025-01-01" = 2106.899056,
  "2025-02-01" = 2124.636295,
  "2025-03-01" = 2012.559149
)

expected_lerner <- c(
  "2025-01-01" = 0.349690,
  "2025-02-01" = 0.349771,
  "2025-03-01" = 0.324203
)

expected_panzar <- c(
  "2025-01-01" = -0.6521005440235044,
  "2025-02-01" = 0.8782603115347807,
  "2025-03-01" = 0.24163624132336647
)

expected_boone <- c(
  "2025-01-01" = 1.0392723995926583,
  "2025-02-01" = 3.4483401612826783,
  "2025-03-01" = -0.641099503866426
)

# helper to extract numeric from various return types
extract_period_value <- function(result, period, key_candidates = c("HHI","hhi","Lerner","lerner","H","Boone","boone")) {
  # numeric
  if (is.numeric(result) && length(result) == 1) return(as.numeric(result))
  # list (named)
  if (is.list(result)) {
    # direct period
    if (!is.null(result[[period]])) {
      v <- result[[period]]
      if (is.numeric(v)) return(as.numeric(v))
      if (is.list(v)) {
        for (k in key_candidates) if (!is.null(v[[k]])) return(as.numeric(v[[k]]))
        # find first numeric in v
        nums <- unlist(Filter(is.numeric, v))
        if (length(nums) > 0) return(as.numeric(nums[1]))
      }
    }
    # named top-level keys
    for (k in key_candidates) {
      if (!is.null(result[[k]])) {
        cand <- result[[k]]
        # cand could be numeric vector named by period
        if (is.numeric(cand) && !is.null(names(cand)) && period %in% names(cand)) {
          return(as.numeric(cand[period]))
        }
        if (is.data.frame(cand)) {
          if ("Period" %in% names(cand)) {
            row <- cand[cand$Period == period, , drop = FALSE]
            if (nrow(row) > 0) {
              # try the key column
              if (k %in% names(row)) return(as.numeric(row[[k]][1]))
              # else return first numeric column
              numcols <- sapply(row, is.numeric)
              if (any(numcols)) return(as.numeric(row[[which(numcols)[1]]][1]))
            }
          }
        }
      }
    }
  }
  # data.frame
  if (is.data.frame(result)) {
    if ("Period" %in% names(result)) {
      row <- result[result$Period == period, , drop = FALSE]
      if (nrow(row) > 0) {
        # prefer known keys
        for (k in key_candidates) if (k %in% names(row)) return(as.numeric(row[[k]][1]))
        # else first numeric column
        numcols <- sapply(row, is.numeric)
        if (any(numcols)) return(as.numeric(row[[which(numcols)[1]]][1]))
      }
    } else {
      # if single-row DF with numeric
      if (nrow(result) == 1) {
        numcols <- sapply(result, is.numeric)
        if (any(numcols)) return(as.numeric(result[[which(numcols)[1]]][1]))
      }
    }
  }
  stop(sprintf("Could not extract numeric value for period %s", period))
}
