
# # Phase 2 — Regression Modeling -----------------------------------------
# Load data
setwd("C:/Users/hp/Desktop/AD OPTIMIZATION/notebooks")
advert <- read.csv("C:/Users/hp/Desktop/AD OPTIMIZATION/data/advertising.csv")

# Fit multiple linear regression model: Sales ~ TV + Radio + Newspaper
model <- lm(Sales ~ TV + Radio + Newspaper, data = advert)

# Display model summary (coefficients, p-values, R-squared)
summary(model)
plot(model)

