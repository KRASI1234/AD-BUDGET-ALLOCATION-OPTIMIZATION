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

---

## Phase 5: R Validation of Excel Solver Optimization

To independently validate the Excel Solver solution, the same Linear Programming model was implemented in **R** using the `lpSolve` package.

The R implementation used the same regression coefficients, budget constraint, channel capacity constraints, and non-negativity requirements as the Excel Solver model.

### R Model Specification

The objective coefficients were:

| Channel | Regression Coefficient |
|---|---:|
| **TV** | 0.05445 |
| **Radio** | 0.10700 |
| **Newspaper** | 0.00034 |

The regression intercept was **4.6251**.

The available advertising budget was **$200.8605 thousand**, with the following historical maximum expenditure constraints:

- TV ≤ $296.40 thousand
- Radio ≤ $49.60 thousand
- Newspaper ≤ $114.00 thousand

The R model was solved using the `lp()` function from the `lpSolve` package.

### R Optimization Results

The R implementation produced the following optimal allocation:

| Channel | R Optimal Allocation ($000s) |
|---|---:|
| **TV** | 151.2605 |
| **Radio** | 49.6000 |
| **Newspaper** | 0.0000 |
| **Total** | **200.8605** |

The resulting predicted Sales were:

$$
S_{optimized} = 18.16843
$$

### Baseline vs. Optimized Performance

Using the same regression model, the baseline allocation produced predicted Sales of:

$$
S_{baseline} = 15.1312
$$

The optimized allocation produced predicted Sales of:

$$
S_{optimized} = 18.16843
$$

The absolute improvement was:

$$
18.16843 - 15.1312 = 3.037234
$$

The percentage improvement was:

$$
\frac{3.037234}{15.1312} \times 100 = 20.07266\%
$$

Therefore, the optimized allocation produces an approximately **20.07% increase in predicted Sales** compared with the baseline allocation, without increasing the total advertising budget.
### Excel Solver vs. R Validation

| Metric | Excel Solver | R `lpSolve` |
|---|---:|---:|
| **TV allocation ($000s)** | 151.2605 | 151.2605 |
| **Radio allocation ($000s)** | 49.6000 | 49.6000 |
| **Newspaper allocation ($000s)** | 0.0000 | 0.0000 |
| **Total budget ($000s)** | 200.8605 | 200.8605 |
| **Optimized Predicted Sales** | 18.1684 | 18.16843 |
| **Sales Improvement (%)** | 20.07% | 20.07266% |

The two implementations produce the same optimal allocation and essentially identical predicted Sales. The minor difference in displayed precision is due to numerical rounding.

### Validation Conclusion

The independent R implementation successfully reproduces the Excel Solver solution. Both methods identify the same optimal allocation:

$$
x_1 = 151.2605,\quad
x_2 = 49.6000,\quad
x_3 = 0
$$

This provides an independent computational check of the Linear Programming optimization.

The results confirm that reallocating the existing advertising budget toward TV and Radio, while eliminating Newspaper expenditure under the specified constraints, increases model-predicted Sales by approximately **20.07% without increasing the total advertising budget**.
---

## Phase 6: Sensitivity Analysis

Sensitivity analysis was conducted to evaluate how changes in the constraints and regression coefficients could affect the optimal advertising allocation. The analysis identifies **binding and non-binding constraints**, measures available slack, and examines the **shadow prices** and sensitivity ranges associated with the Linear Programming model.

### 6.1 Constraint Status

A constraint is **binding** when it is satisfied exactly at the optimal solution, meaning that its slack is zero. A **non-binding** constraint has unused capacity and therefore has positive slack.

The sensitivity analysis produced the following results:

| Constraint | RHS | Used | Slack | Status | Shadow Price |
|---|---:|---:|---:|---|---:|
| **Total Budget** | 200.8605 | 200.8605 | 0.0000 | **Binding** | 0.05445 |
| **TV Maximum** | 296.4000 | 151.2605 | 145.1395 | **Non-binding** | 0.00000 |
| **Radio Maximum** | 49.6000 | 49.6000 | 0.0000 | **Binding** | 0.05255 |
| **Newspaper Maximum** | 114.0000 | 0.0000 | 114.0000 | **Non-binding** | 0.00000 |

### 6.2 Binding Constraints

Two constraints are binding at the optimal solution:

#### Total Budget

The total budget constraint is:

$$
x_1+x_2+x_3 \leq 200.8605
$$

At the optimum:

$$
151.2605+49.6000+0=200.8605
$$

Therefore, the entire available advertising budget is used and the constraint has zero slack.

The shadow price of the budget constraint is:

$$
0.05445
$$

This indicates that, within the applicable sensitivity range, an additional $1,000 of available advertising budget would increase the LP objective by approximately **0.05445 thousand units of predicted Sales**, provided the current optimal basis remains unchanged.

#### Radio Maximum

The Radio constraint is:

$$
x_2 \leq 49.60
$$

The optimal solution allocates:

$$
x_2=49.60
$$

Therefore, the Radio capacity constraint is also binding.

Its shadow price is:

$$
0.05255
$$

This positive shadow price indicates that the Radio upper bound is restricting the optimal solution. The model would benefit from additional Radio capacity if the constraint were relaxed.

### 6.3 Non-Binding Constraints

#### TV Maximum

The TV constraint is:

$$
x_1 \leq 296.40
$$

The optimal TV allocation is only:

$$
x_1=151.2605
$$

Therefore, unused TV capacity is:

$$
296.40-151.2605=145.1395
$$

The TV constraint is consequently non-binding, with a shadow price of zero.

Increasing the TV maximum would not improve the objective under the current solution because the model is not constrained by TV capacity.

#### Newspaper Maximum

The Newspaper constraint is:

$$
x_3 \leq 114.00
$$

The optimized allocation is:

$$
x_3=0
$$

Therefore, the model has 114 thousand dollars of unused Newspaper capacity.

The constraint is non-binding and has a shadow price of zero.

Importantly, the zero Newspaper allocation is **not caused by the Newspaper upper bound**. The model voluntarily allocates nothing to Newspaper because its estimated marginal return is substantially lower than those of TV and Radio.

---

### 6.4 Objective-Coefficient Sensitivity

The sensitivity analysis also examined the range over which each regression coefficient can change without changing the current optimal basis.

| Channel | Current Coefficient | Lower Bound | Upper Bound |
|---|---:|---:|---:|
| **TV** | 0.05445 | 0.00034 | 0.10700 |
| **Radio** | 0.10700 | 0.05445 | Unbounded |
| **Newspaper** | 0.00034 | Unbounded | 0.05445 |

These ranges provide useful information about the robustness of the optimal allocation.

The TV coefficient can vary between **0.00034 and 0.10700** while maintaining the current optimal basis.

The Radio coefficient can decrease to approximately **0.05445** before the current optimal basis changes. Since its current coefficient is **0.10700**, Radio has a substantial margin before losing its current advantage over TV.

The Newspaper coefficient can increase from its current value of **0.00034** up to approximately **0.05445** before the current optimal basis changes. This indicates that Newspaper would need a substantially higher estimated marginal return before the optimizer would allocate funds to it under the current constraints.

---

### 6.5 RHS Sensitivity

The sensitivity analysis also provides ranges for the right-hand-side values of the constraints within which the current shadow prices remain applicable.

| Constraint | Current RHS | Lower Bound | Upper Bound |
|---|---:|---:|---:|
| **Total Budget** | 200.8605 | 49.60 | 346.00 |
| **TV Maximum** | 296.40 | No finite lower limit | No finite upper limit |
| **Radio Maximum** | 49.60 | 0.00 | 200.8605 |
| **Newspaper Maximum** | 114.00 | No finite lower limit | No finite upper limit |

The total budget can therefore vary within the reported sensitivity range while maintaining the same basis, with the budget shadow price remaining applicable.

The Radio upper bound is particularly important. Since the current Radio allocation is exactly equal to its maximum, relaxing this constraint could allow additional funds to be directed toward Radio and increase predicted Sales.

---

### 6.6 Managerial Interpretation

The sensitivity analysis provides several important insights into the advertising allocation problem:

1. **The total advertising budget is fully utilized.**  
   The zero slack on the budget constraint confirms that additional budget has potential value under the model.

2. **Radio capacity is a limiting constraint.**  
   Radio receives the maximum permitted allocation of $49.60 thousand. Its positive shadow price indicates that relaxing the Radio limit could improve the objective.

3. **TV capacity is not restrictive.**  
   The model uses only $151.2605 thousand out of the available $296.40 thousand maximum.

4. **Newspaper capacity is not restrictive.**  
   The model allocates zero to Newspaper despite an upper bound of $114 thousand. The low estimated marginal return, rather than the constraint itself, explains the zero allocation.

5. **The optimal solution is economically interpretable.**  
   The optimizer first favors Radio because it has the highest estimated marginal return. Once the Radio capacity constraint is reached, the remaining budget is allocated to TV. Newspaper receives no allocation because its estimated marginal return is negligible.

### 6.7 Sensitivity Analysis Conclusion

The sensitivity analysis confirms that the optimal solution is primarily constrained by the **available total budget and the maximum allowable Radio expenditure**.

The optimal allocation remains:

$$
x_1=151.2605,\qquad
x_2=49.6000,\qquad
x_3=0
$$

with predicted Sales of:

$$
S_{optimized}=18.16843
$$

The positive shadow prices for the total budget and Radio capacity demonstrate that these are the most economically important constraints in the model. In contrast, the TV and Newspaper upper bounds are non-binding and therefore do not currently restrict the optimal solution.

Overall, the sensitivity analysis suggests that if additional advertising resources become available, **increasing the allowable Radio allocation should be considered before increasing the TV or Newspaper capacity limits**, subject to the validity of the underlying regression model and its assumptions.
---

## Data Source and Tools

### Data Source

The dataset used in this project is the **Advertising Dataset**, obtained from Kaggle. It contains 200 observations of advertising expenditure across **TV, Radio, and Newspaper**, together with corresponding **Sales** values.

**Source:** [Kaggle – Advertising Dataset](https://www.kaggle.com/datasets/ashydv/advertising-dataset)

### Tools Used

- **R** — Exploratory analysis, multiple linear regression, and LP validation using `lpSolve`
- **Microsoft Excel** — LP model implementation and optimization
- **Excel Solver** — Optimization using the Simplex LP method
- **GitHub** — Project documentation and version control
