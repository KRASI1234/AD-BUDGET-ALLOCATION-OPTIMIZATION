# ============================================================
# Phase 5: R Validation of Excel Solver Optimization
# ============================================================

library(lpSolve)

# ------------------------------------------------------------
# 1. Model Parameters
# ------------------------------------------------------------

# Regression coefficients
beta_tv <- 0.05445
beta_radio <- 0.10700
beta_newspaper <- 0.00034

# Regression intercept
intercept <- 4.6251

# Available advertising budget ($000s)
budget <- 200.8605

# Historical maximum expenditure by channel ($000s)
tv_max <- 296.40
radio_max <- 49.60
newspaper_max <- 114.00


# ------------------------------------------------------------
# 2. LP Objective Function
# ------------------------------------------------------------

# Objective coefficients:
# TV, Radio, Newspaper

f.obj <- c(
  beta_tv,
  beta_radio,
  beta_newspaper
)


# ------------------------------------------------------------
# 3. Constraint Matrix
# ------------------------------------------------------------

f.con <- matrix(
  c(
    1, 1, 1,  # Total budget
    1, 0, 0,  # TV maximum
    0, 1, 0,  # Radio maximum
    0, 0, 1   # Newspaper maximum
  ),
  nrow = 4,
  byrow = TRUE
)


# ------------------------------------------------------------
# 4. Constraint Directions and RHS
# ------------------------------------------------------------

f.dir <- c(
  "<=",
  "<=",
  "<=",
  "<="
)

f.rhs <- c(
  budget,
  tv_max,
  radio_max,
  newspaper_max
)


# ------------------------------------------------------------
# 5. Solve Linear Program
# ------------------------------------------------------------

opt <- lp(
  direction = "max",
  objective.in = f.obj,
  const.mat = f.con,
  const.dir = f.dir,
  const.rhs = f.rhs
)


# ------------------------------------------------------------
# 6. Extract Optimal Allocation
# ------------------------------------------------------------

opt_spend <- opt$solution

tv_opt <- opt_spend[1]
radio_opt <- opt_spend[2]
newspaper_opt <- opt_spend[3]


# ------------------------------------------------------------
# 7. Calculate Predicted Sales
# ------------------------------------------------------------

opt_sales <- intercept + opt$objval


# ------------------------------------------------------------
# 8. Display Results
# ------------------------------------------------------------

cat("============================================\n")
cat("R LP OPTIMIZATION RESULTS\n")
cat("============================================\n")

cat("Optimal TV Spend:        ", tv_opt, "\n")
cat("Optimal Radio Spend:     ", radio_opt, "\n")
cat("Optimal Newspaper Spend: ", newspaper_opt, "\n")
cat("Total Budget Used:       ", sum(opt_spend), "\n")
cat("Optimal Expected Sales:  ", opt_sales, "\n")

cat("============================================\n")
# ------------------------------------------------------------
# 9. Baseline Performance
# ------------------------------------------------------------

baseline_tv <- 147.0425
baseline_radio <- 23.2640
baseline_newspaper <- 30.5540

baseline_sales <- intercept +
  beta_tv * baseline_tv +
  beta_radio * baseline_radio +
  beta_newspaper * baseline_newspaper


# ------------------------------------------------------------
# 10. Performance Improvement
# ------------------------------------------------------------

sales_improvement <- opt_sales - baseline_sales

improvement_percent <- 
  (sales_improvement / baseline_sales) * 100


# ------------------------------------------------------------
# 11. Validation Summary
# ------------------------------------------------------------

cat("\n")
cat("============================================\n")
cat("BASELINE VS OPTIMIZED PERFORMANCE\n")
cat("============================================\n")

cat("Baseline Predicted Sales:   ", baseline_sales, "\n")
cat("Optimized Predicted Sales:  ", opt_sales, "\n")
cat("Sales Improvement:          ", sales_improvement, "\n")
cat("Improvement (%):            ", improvement_percent, "%\n")