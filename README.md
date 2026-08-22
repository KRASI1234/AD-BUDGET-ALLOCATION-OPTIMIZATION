# AD-BUDGET-ALLOCATION-OPTIMIZATION

Operations research project optimizing advertising budget allocation across TV, Radio, and Newspaper channels using multiple linear regression and linear programming (Excel Solver + Python).

---

## Phase 1: Exploratory Data Analysis (EDA)

### Dataset Overview

- **Observations:** 200 markets
- **Missing Values:** 0 across all variables
- **Features:** Spend in `TV`, `Radio`, and `Newspaper` ($ thousands), alongside `Sales` (units in thousands).

### Summary Statistics and Current Baseline Allocation

Average spend across all 200 markets establishes our implied baseline budget, denoted by $B$.

| Channel | Mean Spend | Share of Budget (%) | Min Spend | Max Spend |
|---|---:|---:|---:|---:|
| **TV** | 147.04 | 73.2% | 0.70 | 296.40 |
| **Radio** | 23.26 | 11.6% | 0.00 | 49.60 |
| **Newspaper** | 30.55 | 15.2% | 0.30 | 114.00 |
| **Total Baseline ($B$)** | **200.86** | **100.0%** | — | — |

**Average Sales across markets:** 15.13 units.

---

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
- **TV and Radio:** Very weak correlation ($r = 0.055$).
- **TV and Newspaper:** Very weak correlation ($r = 0.057$).
- **Radio and Newspaper:** Moderate correlation ($r = 0.354$).

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
Sales = \beta_0 + \beta_1 TV + \beta_2 Radio + \beta_3 Newspaper + \epsilon
$$

### Fitted Regression Results

| Parameter | Coefficient ($\beta$) | Std. Error | $t$-stat | $p$-value | Significance |
|---|---:|---:|---:|---:|---|
| **Intercept ($\beta_0$)** | 4.6251 | 0.3075 | 15.041 | $< 0.001$ | *** |
| **TV ($\beta_1$)** | 0.05445 | 0.0014 | 39.592 | $< 0.001$ | *** |
| **Radio ($\beta_2$)** | 0.10700 | 0.0085 | 12.604 | $< 0.001$ | *** |
| **Newspaper ($\beta_3$)** | 0.00034 | 0.0058 | 0.058 | 0.954 | Insignificant |

### Model Fit

- **Multiple $R^2$:** 0.9026
- **Adjusted $R^2$:** 0.9011
- **Residual Standard Error:** 1.662 (196 DF)
- **$F$-statistic:** 605.4
- **Overall model $p$-value:** $< 2.2 \times 10^{-16}$

### Statistical Insights and LP Optimization Implications

1. **Radio has the highest estimated marginal return ($\beta_2 = 0.10700$).**  
   Holding TV and Newspaper expenditure constant, an additional $1,000 spent on Radio is associated with an estimated increase of 0.107 thousand units of Sales.

2. **TV has a strong and statistically significant effect ($\beta_1 = 0.05445$).**  
   Holding the other channels constant, an additional $1,000 spent on TV is associated with an estimated increase of 0.05445 thousand units of Sales. The coefficient is highly statistically significant ($p < 0.001$).

3. **Newspaper has a negligible and statistically insignificant estimated effect ($\beta_3 = 0.00034$, $p = 0.954$).**  
   After controlling for TV and Radio expenditure, the model provides little evidence of a marginal relationship between Newspaper spending and Sales.

4. **Estimated marginal-return ranking:**

   $$
   Radio > TV > Newspaper
   $$

   This ranking informs the allocation priorities in the subsequent Linear Programming optimization.

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
| **TV ($x_1$)** | 147.0425 | 73.2% | 0.05445 |
| **Radio ($x_2$)** | 23.2640 | 11.6% | 0.10700 |
| **Newspaper ($x_3$)** | 30.5540 | 15.2% | 0.00034 |
| **Total ($B$)** | **200.8605** | **100.0%** | — |

The baseline allocation represents the historical average advertising expenditure across the 200 markets.

### Baseline Predicted Sales

Using the fitted regression model and the baseline allocation, the predicted Sales level is:

$$
S_{baseline} = 15.13120049
$$

This represents the model-predicted Sales under the historical mean allocation.

---

### Linear Programming (LP) Formulation

The advertising budget allocation problem is formulated as a continuous Linear Program to maximize predicted Sales subject to the available budget, channel capacity constraints, and non-negativity requirements.

#### Decision Variables

- $x_1$: Expenditure on TV advertising ($ in thousands)
- $x_2$: Expenditure on Radio advertising ($ in thousands)
- $x_3$: Expenditure on Newspaper advertising ($ in thousands)

#### Objective Function

Using the regression coefficients implemented in Excel Solver, the fitted regression model is:

$$
S = 4.6251 + 0.05445x_1 + 0.10700x_2 + 0.00034x_3
$$

Therefore, the LP objective is:

$$
Maximize \quad S = 4.6251 + 0.05445x_1 + 0.10700x_2 + 0.00034x_3
$$

Since the intercept $4.6251$ is constant, maximizing predicted Sales is equivalent to maximizing:

$$
0.05445x_1 + 0.10700x_2 + 0.00034x_3
$$

#### Constraints

**1. Total Budget Constraint**

The total advertising expenditure cannot exceed the available baseline budget:

$$
x_1 + x_2 + x_3 \leq 200.8605
$$

**2. Channel Capacity Constraints**

Each channel is constrained by its maximum historical expenditure:

$$
x_1 \leq 296.40
$$

$$
x_2 \leq 49.60
$$

$$
x_3 \leq 114.00
$$

**3. Non-Negativity Constraints**

Advertising expenditure cannot be negative:

$$
x_1 \geq 0
$$

$$
x_2 \geq 0
$$

$$
x_3 \geq 0
$$

---

## Phase 4: Excel Solver Optimization

### Solver Implementation

The Linear Programming model developed in Phase 3 was implemented in Microsoft Excel using the **Solver Add-in**.

The objective was to maximize predicted Sales by determining the optimal allocation of the fixed advertising budget across TV, Radio, and Newspaper.

#### Solver Configuration

| Solver Component | Specification |
|---|---|
| **Objective Cell** | Predicted Sales |
| **Optimization Direction** | Maximize |
| **Changing Variable Cells** | TV, Radio, Newspaper allocations |
| **Solving Method** | Simplex LP |
| **Budget Constraint** | Total allocation ≤ $200.8605k |
| **TV Upper Bound** | ≤ $296.40k |
| **Radio Upper Bound** | ≤ $49.60k |
| **Newspaper Upper Bound** | ≤ $114.00k |
| **Non-Negativity** | All allocations ≥ 0 |

The regression coefficients used in the Excel optimization model were:

| Channel | Regression Coefficient |
|---|---:|
| **TV** | 0.05445 |
| **Radio** | 0.10700 |
| **Newspaper** | 0.00034 |

The intercept was **4.6251**.

### Optimal Budget Allocation

Excel Solver produced the following optimal allocation:

| Channel | Baseline Spend ($000s) | Optimized Spend ($000s) | Change ($000s) | Change (%) |
|---|---:|---:|---:|---:|
| **TV** | 147.0425 | 151.2605 | +4.2180 | +2.87% |
| **Radio** | 23.2640 | 49.6000 | +26.3360 | +113.20% |
| **Newspaper** | 30.5540 | 0.0000 | -30.5540 | -100.00% |
| **Total** | **200.8605** | **200.8605** | **0.0000** | **0.00%** |

The total advertising budget remains unchanged at **$200.8605 thousand**. Therefore, the optimization represents a **reallocation of the existing budget rather than an increase in total expenditure**.

### Optimal Solution

The Solver solution is:

$$
x_1 = 151.2605
$$

$$
x_2 = 49.6000
$$

$$
x_3 = 0
$$

where:

- $x_1$ = TV expenditure
- $x_2$ = Radio expenditure
- $x_3$ = Newspaper expenditure

The budget constraint is binding:

$$
151.2605 + 49.6000 + 0 = 200.8605
$$

Thus, the entire available budget is allocated.

### Predicted Sales Improvement

The baseline allocation produces predicted Sales of:

$$
S_{baseline} = 15.13120049
$$

Under the optimized allocation, predicted Sales increase to:

$$
S_{optimized} = 18.16843423
$$

The absolute improvement is:

$$
18.16843423 - 15.13120049 = 3.03723374
$$

The percentage improvement is:

$$
\frac{18.16843423 - 15.13120049}{15.13120049} \times 100
\approx 20.07\%
$$

### Optimization Result

| Metric | Baseline | Optimized | Improvement | Improvement (%) |
|---|---:|---:|---:|---:|
| **Predicted Sales** | 15.1312 | 18.1684 | +3.0372 | **20.07%** |
| **Total Budget ($000s)** | 200.8605 | 200.8605 | 0.0000 | **0.00%** |

### Interpretation

The optimization reallocates advertising expenditure toward channels with higher estimated marginal returns.

- **Radio receives the largest increase**, rising from $23.264k to $49.600k. This reflects its highest estimated marginal return of **0.10700**.
- **TV expenditure increases moderately**, from $147.0425k to $151.2605k, reflecting its second-highest marginal return of **0.05445**.
- **Newspaper expenditure falls to zero**, consistent with its very small estimated marginal return of **0.00034**.
- The **total advertising budget remains unchanged**, meaning that the improvement comes from reallocating the existing budget rather than increasing total expenditure.

Overall, the Linear Programming model indicates that reallocating the existing advertising budget according to the estimated marginal returns could increase predicted Sales by approximately **20.07%**.
