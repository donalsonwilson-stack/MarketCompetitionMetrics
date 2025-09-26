library(dplyr)
library(ggplot2)
library(broom)

MarketCompetitionMetrics <- list(

  # ------------------------------------------------------------
  # HHI
  # ------------------------------------------------------------
  hhi = function(data, share_col, period_col = NULL, plot = FALSE) {
    if (!is.null(period_col)) {
      hhi_values <- data %>%
        group_by(.data[[period_col]]) %>%
        summarise(HHI = sum((.data[[share_col]])^2), .groups = "drop")
      
      if (plot) {
        p <- ggplot(hhi_values, aes(x = .data[[period_col]], y = HHI, group = 1)) +
          geom_line(color = "blue") +
          geom_point(color = "blue") +
          ggtitle("Evolution of the HHI Index over Time") +
          theme_minimal()
        print(p)
      }
      return(setNames(as.list(hhi_values$HHI), hhi_values[[period_col]]))
    } else {
      return(sum(data[[share_col]]^2))
    }
  },

  # ------------------------------------------------------------
  # Lerner
  # ------------------------------------------------------------
  lerner = function(data, firm_col, price_col, cost_col, share_col, 
                    period_col = NULL, plot = FALSE, stacked = FALSE) {
    compute_lerner <- function(df) {
      df$Lerner_i <- (df[[price_col]] - df[[cost_col]]) / df[[price_col]]
      L_market <- sum(df[[share_col]] * df$Lerner_i)
      df$contribution <- df[[share_col]] * df$Lerner_i
      return(list(market = L_market, contributions = df[, c(firm_col, "contribution")]))
    }
    
    if (!is.null(period_col)) {
      results <- lapply(split(data, data[[period_col]]), compute_lerner)
      
      # Graph
      if (plot) {
        market_dict <- sapply(results, function(x) x$market)
        df_plot <- data.frame(Period = names(market_dict), Market = as.numeric(market_dict))
        
        p <- ggplot(df_plot, aes(x = Period, y = Market, group = 1)) +
          geom_line(color = "green") +
          geom_point(color = "green") +
          ggtitle("Market Lerner Index Over Time") +
          theme_minimal()
        print(p)
      }
      return(results)
    } else {
      return(compute_lerner(data))
    }
  },

  # ------------------------------------------------------------
  # Panzar-Rosse
  # ------------------------------------------------------------
  panzar_rosse = function(data, revenue_col, input_cols, period_col = NULL, plot = FALSE) {
    compute_pr <- function(df) {
      formula_str <- paste0("log(", revenue_col, ") ~ ", paste0("log(", input_cols, ")", collapse = " + "))
      model <- lm(as.formula(formula_str), data = df)
      H <- sum(coef(model)[-1])
      return(list(H = H, summary = summary(model)))
    }
    
    if (!is.null(period_col)) {
      results <- lapply(split(data, data[[period_col]]), compute_pr)
      
      # Graph
      if (plot) {
        H_values <- sapply(results, function(x) x$H)
        df_plot <- data.frame(Period = names(H_values), H = as.numeric(H_values))
        
        p <- ggplot(df_plot, aes(x = Period, y = H, group = 1)) +
          geom_line(color = "blue") +
          geom_point(color = "blue") +
          ggtitle("Evolution of Panzar-Rosse H-statistic Over Time") +
          theme_minimal()
        print(p)
      }
      return(results)
    } else {
      return(compute_pr(data))
    }
  },

  # ------------------------------------------------------------
  # Boone
  # ------------------------------------------------------------
  boone = function(data, cost_cols, profit_col, period_col = NULL, plot = FALSE) {
    compute_boone <- function(df) {
      formula_str <- paste0("log(", profit_col, ") ~ ", paste0("log(", cost_cols, ")", collapse = " + "))
      model <- lm(as.formula(formula_str), data = df)
      betas <- coef(model)[-1]
      beta_dict <- as.list(betas)
      names(beta_dict) <- cost_cols
      Boone <- sum(betas)
      return(list(Boone = Boone, coefficients = beta_dict, summary = summary(model)))
    }
    
    if (!is.null(period_col)) {
      results <- lapply(split(data, data[[period_col]]), compute_boone)
      
      # Graph
      if (plot) {
        Boone_values <- sapply(results, function(x) x$Boone)
        df_plot <- data.frame(Period = names(Boone_values), Boone = as.numeric(Boone_values))
        
        p <- ggplot(df_plot, aes(x = Period, y = Boone, group = 1)) +
          geom_line(color = "red") +
          geom_point(color = "red") +
          ggtitle("Evolution of Boone Indicator Over Time") +
          theme_minimal()
        print(p)
      }
      return(results)
    } else {
      return(compute_boone(data))
    }
  }
)