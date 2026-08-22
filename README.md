# AD-BUDGET-ALLOCATION-OPTIMIZATION

Operations research project optimizing advertising budget allocation across TV, Radio, and Newspaper channels using multiple linear regression and linear programming (Excel Solver + Python).

## Phase 1: Exploratory Data Analysis (EDA)

### Dataset Overview

- **Observations:** 200 markets
- **Missing Values:** 0 across all variables
- **Features:** Spend in `TV`, `Radio`, and `Newspaper` ($ thousands), alongside `Sales` (units in thousands).

### Summary Statistics and Current Baseline Allocation

Average spend across all 200 markets establishes our implied baseline budget ($B$).

| Channel | Mean Spend | Share of Budget (%) | Min Spend | Max Spend |
|---|---:|---:|---:|---:|
| **TV** | 147.04 | 73.2% | 0.70 | 296.40 |
| **Radio** | 23.26 | 11.6% | 0.00 | 49.60 |
| **Newspaper** | 30.55 | 15.2% | 0.30 | 114.00 |
| **Total Baseline ($B$)** | **200.86** | **100.0%** | — | — |

**Average Sales across markets:** 15.13 units.

### Correlation Analysis

The correlation matrix evaluates the relationships between advertising expenditure and Sales, as well as potential multicollinearity among the predictor variables.

| | TV | Radio | Newspaper | Sales |
|---|---:|---:|---:|---:|
| **TV** | 1.000 | 0.055 | 0.057 | **0.901** |
| **Radio** | 0.055 | 1.000 | 0.354 | **0.350** |
| **Newspaper** | 0.057 | 0.354 | 1.000 | **0.158** |
| **Sales** | **0.901** | **0.350** | **0.158** | 1.000 |

#### Key Findings

- **TV and Sales:** Strong positive correlation ($r = 0.901$), indicating a strong association between TV advertising expenditure and Sales.
- **Radio and Sales:** Moderate positive correlation ($r = 0.350$).
- **Newspaper and Sales:** Weak positive correlation ($r = 0.158$).
- **TV and Radio:** Very weak correlation ($r = 0.055$), suggesting little evidence of coordinated spending between the two channels.
- **TV and Newspaper:** Very weak correlation ($r = 0.057$).
- **Radio and Newspaper:** Moderate correlation ($r = 0.354$), indicating some association between spending on the two channels.

The relatively low correlations among the advertising channels suggest that severe multicollinearity is unlikely to be a major concern for the regression model.

### Correlation with Sales

The pairwise correlations between each advertising channel and Sales are summarized below.

| Channel | Correlation with Sales ($r$) |
|---|---:|
| **TV** | 0.9012 |
| **Radio** | 0.3496 |
| **Newspaper** | 0.1580 |
| **Sales** | 1.0000 |

- **TV vs. Sales ($r = 0.901$):** Strong positive correlation, indicating that markets with higher TV expenditure tend to have higher Sales.
- **Radio vs. Sales ($r = 0.350$):** Moderate positive correlation.
- **Newspaper vs. Sales ($r = 0.158$):** Weak positive correlation, suggesting a relatively weak unconditional relationship with Sales.
- **Inter-channel Correlation:** TV and Radio show near-zero correlation ($r = 0.055$), while Radio and Newspaper show moderate correlation ($r = 0.354$).

Correlation measures pairwise association and does not account for the simultaneous effect of all advertising channels. Multiple linear regression is therefore used to estimate the marginal contribution of each channel while controlling for the others.

---

## Phase 2: Regression Modeling

### Model Specification

We fit a Multiple Linear Regression model predicting `Sales` based on advertising expenditure across all three media channels:

$$
\text{Sales} = \beta_0 + \beta_1(\text{TV}) + \beta_2(\text{Radio}) + \beta_3(\text{Newspaper}) + \epsilon
$$

### Fitted Regression Results

| Parameter | Coefficient ($\beta$) | Std. Error | $t$-stat | $p$-value | Significance |
|---|---:|---:|---:|---:|---|
| **Intercept ($\beta_0$)** | 4.6251 | 0.3075 | 15.041 | $< 0.001$ | *** |
| **TV ($\beta_1$)** | 0.0544 | 0.0014 | 39.592 | $< 0.001$ | *** |
| **Radio ($\beta_2$)** | 0.1070 | 0.0085 | 12.604 | $< 0.001$ | *** |
| **Newspaper ($\beta_3$)** | 0.0003 | 0.0058 | 0.058 | 0.954 | Insignificant |

### Model Fit

- **Multiple $R^2$:** 0.9026
- **Adjusted $R^2$:** 0.9011
- **Residual Standard Error:** 1.662 (196 DF)
- **$F$-statistic:** 605.4
- **Overall model $p$-value:** $< 2.2 \times 10^{-16}$

### Statistical Insights and LP Optimization Implications

1. **Radio has the highest estimated marginal return ($\beta_2 = 0.1070$).**  
   Holding TV and Newspaper expenditure constant, an additional $1,000 spent on Radio is associated with an estimated increase of 0.107 thousand units of Sales.

2. **TV has a strong and statistically significant effect ($\beta_1 = 0.0544$).**  
   Holding the other channels constant, an additional $1,000 spent on TV is associated with an estimated increase of 0.0544 thousand units of Sales. The coefficient is highly statistically significant ($p < 0.001$).

3. **Newspaper has a negligible and statistically insignificant estimated effect ($\beta_3 = 0.0003, p = 0.954$).**  
   After controlling for TV and Radio expenditure, the model provides little evidence of a marginal relationship between Newspaper spending and Sales.

4. **The estimated marginal-return ranking is:**

   $$
   \text{Radio} > \text{TV} > \text{Newspaper}
   $$

   This ranking will inform the allocation priorities in the subsequent Linear Programming optimization.

---

## Phase 3: Baseline Budget and Mathematical Formulation

### Current Baseline Allocation

Using mean historical market spending as the reference baseline budget:

$$
B = 200.8605
$$

The current allocation is:

| Channel | Current Mean Spend ($x_i$) | Current Share (%) | Marginal Return ($\beta_i$) |
|---|---:|---:|---:|
| **TV ($x_1$)** | 147.0425 | 73.2% | 0.0544 |
| **Radio ($x_2$)** | 23.2640 | 11.6% | 0.1070 |
| **Newspaper ($x_3$)** | 30.5540 | 15.2% | 0.0003 |
| **Total ($B$)** | **200.8605** | **100.0%** | — |

The baseline allocation corresponds to the historical average advertising expenditure across the 200 markets.

### Baseline Predicted Sales

Using the fitted regression equation and the baseline allocation, the predicted Sales level is approximately:

$$
\hat{S}_{\text{baseline}} \approx 15.132
$$

This represents the model-predicted Sales under the historical mean allocation.

---

### Linear Programming (LP) Formulation

The advertising budget allocation problem is formulated as a continuous Linear Program to maximize predicted Sales subject to the available budget, channel capacity constraints, and non-negativity requirements.

#### Decision Variables

- $x_1$: Expenditure on TV advertising ($ in thousands)
- $x_2$: Expenditure on Radio advertising ($ in thousands)
- $x_3$: Expenditure on Newspaper advertising ($ in thousands)

#### Objective FunctionThe fitted regression model is:

$$
\hat{S}(x_1,x_2,x_3)
=
4.6251
+
0.0544x_1
+
0.1070x_2
+
0.0003x_3
$$

Therefore, the LP objective is:

$$
\max \hat{S}(x_1,x_2,x_3)
=
4.6251
+
0.0544x_1
+
0.1070x_2
+
0.0003x_3
$$

Since the intercept $4.6251$ is constant, maximizing predicted Sales is equivalent to maximizing:

$$
0.0544x_1
+
0.1070x_2
+
0.0003x_3
$$
$$
