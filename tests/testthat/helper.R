# tests/testthat/helper.R
library(testthat)

# ---------------------------
# Build dataset for tests (hard-coded)
# ---------------------------
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
  num_cols <- c("Revenue","Profit","Labor_cost","Capital_cost","Wage_cost",
                "Price","Marginal_cost","Market_share","Income")
  df[num_cols] <- lapply(df[num_cols], as.numeric)
  df$Period <- as.character(df$Period)
  df$Firm <- as.character(df$Firm)
  rownames(df) <- NULL
  return(df)
}

# ---------------------------
# Expected values (same numbers used in Python tests) - named numeric vectors
# ---------------------------
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
  "2025-01-01" = -0.7163349,
  "2025-02-01" = 2.399426,
  "2025-03-01" = 0.08148894
)

expected_boone <- c(
  "2025-01-01" = 1.039272,
  "2025-02-01" = 3.44834,
  "2025-03-01" = -0.6410995
)

# ---------------------------
extract_period_value <- function(result, period, key_candidates = c("HHI","hhi","Lerner","lerner","H","Boone","boone")) {
  as_num_scalar <- function(x) {
    if (is.null(x)) return(NA_real_)
    v <- suppressWarnings(as.numeric(unname(x)))
    if (length(v) == 0) return(NA_real_)
    # round to 6 decimals (matches expected precision)
    return(round(v[[1]], 6))
  }

  # numeric scalar
  if (is.numeric(result) && length(result) == 1) return(as_num_scalar(result))

  # list (named) -> check direct period key first
  if (is.list(result)) {
    if (!is.null(result[[period]])) {
      v <- result[[period]]
      if (is.numeric(v) && length(v) >= 1) return(as_num_scalar(v))
      if (is.list(v)) {
        for (k in key_candidates) if (!is.null(v[[k]])) return(as_num_scalar(v[[k]]))
        nums <- unlist(Filter(is.numeric, v))
        if (length(nums) > 0) return(as_num_scalar(nums[1]))
      }
    }

    # named top-level keys (e.g. result$H or result$HHI)
    for (k in key_candidates) {
      if (!is.null(result[[k]])) {
        cand <- result[[k]]
        if (is.numeric(cand) && !is.null(names(cand)) && period %in% names(cand)) {
          return(as_num_scalar(cand[period]))
        }
        if (is.data.frame(cand) && "Period" %in% names(cand)) {
          row <- cand[cand$Period == period, , drop = FALSE]
          if (nrow(row) > 0) {
            if (k %in% names(row)) return(as_num_scalar(row[[k]][1]))
            numcols <- sapply(row, is.numeric)
            if (any(numcols)) return(as_num_scalar(row[[which(numcols)[1]]][1]))
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
        for (k in key_candidates) if (k %in% names(row)) return(as_num_scalar(row[[k]][1]))
        numcols <- sapply(row, is.numeric)
        if (any(numcols)) return(as_num_scalar(row[[which(numcols)[1]]][1]))
      }
    } else {
      if (nrow(result) == 1) {
        numcols <- sapply(result, is.numeric)
        if (any(numcols)) return(as_num_scalar(result[[which(numcols)[1]]][1]))
      }
    }
  }

  stop(sprintf("Could not extract numeric value for period %s", period))
}
