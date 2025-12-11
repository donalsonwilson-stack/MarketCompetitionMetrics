library(testthat)

# ---------------------------
# Helpers to locate + read CSV
# ---------------------------
get_test_csv_path <- function() {
  # 1) prefer local inst/extdata (when running from source)
  local_path <- file.path("inst", "extdata", "Synthetic_Market_Data.csv")
  if (file.exists(local_path)) return(normalizePath(local_path))

  # 2) if the package is installed, check system.file
  pkg_path <- system.file("extdata", "Synthetic_Market_Data.csv", package = "MarketCompetitionMetrics")
  if (nzchar(pkg_path) && file.exists(pkg_path)) return(normalizePath(pkg_path))

  # not found
  return(NULL)
}

safe_read_market_csv <- function(path) {
  if (is.null(path)) stop("safe_read_market_csv: path is NULL")

  # try to read first lines to detect separator
  first_lines <- tryCatch(readLines(path, n = 5, warn = FALSE), error = function(e) character(0))
  sep <- if (length(first_lines) > 0 && any(grepl(";", first_lines, fixed = TRUE))) ";" else ","

  # attempt to read with safe options and handle BOM if present
  df <- tryCatch(
    {
      # use read.table to allow fill = TRUE if some rows have fewer fields
      read.table(path,
                 header = TRUE,
                 sep = sep,
                 dec = ".",
                 stringsAsFactors = FALSE,
                 fill = TRUE,
                 comment.char = "",
                 quote = "\"'",
                 fileEncoding = "UTF-8-BOM",
                 na.strings = c("", "NA"))
    },
    error = function(e) {
      stop("Failed to read CSV '", path, "': ", conditionMessage(e))
    }
  )

  # make sure result is a data.frame
  df <- as.data.frame(df, stringsAsFactors = FALSE)
  # trim whitespace in column names and remove possible BOM in first name
  # use unicode escape for safety
  names(df) <- trimws(gsub("\uFEFF", "", names(df), fixed = FALSE))
  return(df)
}

# ---------------------------
# Build dataset for tests
# ---------------------------
csv_path <- get_test_csv_path()
if (!is.null(csv_path)) {
  test_data <- tryCatch(
    {
      d <- safe_read_market_csv(csv_path)
      # ensure numeric columns are numeric (robust to CSV)
      num_cols <- c("Revenue", "Profit", "Labor_cost", "Capital_cost", "Wage_cost",
                    "Price", "Marginal_cost", "Market_share", "Income")
      for (nc in intersect(num_cols, names(d))) {
        d[[nc]] <- suppressWarnings(as.numeric(d[[nc]]))
      }
      # ensure key character columns
      if ("Period" %in% names(d)) d$Period <- as.character(d$Period)
      if ("Firm" %in% names(d)) d$Firm <- as.character(d$Firm)
      rownames(d) <- NULL
      d
    },
    error = function(e) {
      message("Could not read CSV at: ", csv_path, " — falling back to built-in constructor. (", conditionMessage(e), ")")
      NULL
    }
  )

  if (!is.null(test_data)) {
    build_df <- function() {
      return(test_data)
    }
  }
}

# fallback constructor if CSV missing/unreadable
if (!exists("build_df")) {
  warning("Synthetic_Market_Data.csv not found or unreadable — using built-in constructor fallback.")

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
    num_cols <- c("Revenue", "Profit", "Labor_cost", "Capital_cost", "Wage_cost",
                  "Price", "Marginal_cost", "Market_share", "Income")
    df[num_cols] <- lapply(df[num_cols], as.numeric)
    return(df)
  }
}

# ---------------------------
# Expected values (same numbers used in Python tests)
# rounded at 1e-6 for stable comparisons/visual checks
# ---------------------------
expected_hhi <- round(c(
  "2025-01-01" = 2106.899056,
  "2025-02-01" = 2124.636295,
  "2025-03-01" = 2012.559149
), 6)

expected_lerner <- round(c(
  "2025-01-01" = 34.968959,
  "2025-02-01" = 34.977133,
  "2025-03-01" = 32.420292
), 6)

expected_panzar <- round(c(
  "2025-01-01" = -0.652101,
  "2025-02-01" = 0.878260,
  "2025-03-01" = 0.241636
), 6)

expected_boone <- round(c(
  "2025-01-01" = 1.039272,
  "2025-02-01" = 3.44834,
  "2025-03-01" = -0.6410995
), 6)

# helper to extract numeric from various return types and round to 1e-6
extract_period_value <- function(result, period, key_candidates = c("HHI","hhi","Lerner","lerner","H","Boone","boone")) {
  # helper to coerce, drop names and round to 6 decimals
  as_num_unnamed <- function(x) {
    if (is.null(x)) return(NA_real_)
    v <- suppressWarnings(as.numeric(unname(x)))
    if (length(v) == 0) return(NA_real_)
    return(round(v[[1]], 6))
  }

  # numeric scalar
  if (is.numeric(result) && length(result) == 1) return(as_num_unnamed(result))

  # list (named)
  if (is.list(result)) {
    # direct period entry (result[["2025-01-01"]] etc.)
    if (!is.null(result[[period]])) {
      v <- result[[period]]
      if (is.numeric(v) && length(v) >= 1) return(as_num_unnamed(v))
      if (is.list(v)) {
        for (k in key_candidates) if (!is.null(v[[k]])) return(as_num_unnamed(v[[k]]))
        # find first numeric in v
        nums <- unlist(Filter(is.numeric, v))
        if (length(nums) > 0) return(as_num_unnamed(nums[1]))
      }
    }

    # named top-level keys (e.g., result$HHI or result$hhi etc.)
    for (k in key_candidates) {
      if (!is.null(result[[k]])) {
        cand <- result[[k]]
        # cand could be numeric vector named by period
        if (is.numeric(cand) && !is.null(names(cand)) && period %in% names(cand)) {
          return(as_num_unnamed(cand[period]))
        }
        if (is.data.frame(cand)) {
          if ("Period" %in% names(cand)) {
            row <- cand[cand$Period == period, , drop = FALSE]
            if (nrow(row) > 0) {
              # try the key column
              if (k %in% names(row)) return(as_num_unnamed(row[[k]][1]))
              # else return first numeric column
              numcols <- sapply(row, is.numeric)
              if (any(numcols)) return(as_num_unnamed(row[[which(numcols)[1]]][1]))
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
        for (k in key_candidates) if (k %in% names(row)) return(as_num_unnamed(row[[k]][1]))
        # else first numeric column
        numcols <- sapply(row, is.numeric)
        if (any(numcols)) return(as_num_unnamed(row[[which(numcols)[1]]][1]))
      }
    } else {
      # if single-row DF with numeric
      if (nrow(result) == 1) {
        numcols <- sapply(result, is.numeric)
        if (any(numcols)) return(as_num_unnamed(result[[which(numcols)[1]]][1]))
      }
    }
  }

  stop(sprintf("Could not extract numeric value for period %s", period))
}

