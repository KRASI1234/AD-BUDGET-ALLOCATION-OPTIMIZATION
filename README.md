# AD-BUDGET-ALLOCATION-OPTIMIZATION
Operations research project optimizing advertising budget allocation across TV, Radio, and Newspaper channels using linear regression and linear programming (Excel Solver + Python).
## Phase 1: Exploratory Data Analysis (EDA)

### Dataset Overview
* **Observations:** 200 markets
* **Missing Values:** 0 across all variables
* **Features:** Spend in `TV`, `Radio`, and `Newspaper` ($ thousands), alongside `Sales` (units in thousands).

### Summary Statistics & Current Baseline Allocation
Average spend across all 200 markets establishes our implied baseline budget ($B$):

| Channel | Mean Spend | Share of Budget (%) | Min Spend | Max Spend |
| :--- | :--- | :--- | :--- | :--- |
| **TV** | 147.04 | 73.2% | 0.70 | 296.40 |
| **Radio** | 23.26 | 11.6% | 0.00 | 49.60 |
| **Newspaper** | 30.55 | 15.2% | 0.30 | 114.00 |
| **Total Baseline ($B$)** | **200.86** | **100.0%** | — | — |

*Average Sales across markets:* **15.13** units.

### Linear Correlation Analysis

### Correlation Matrix
Evaluates potential **multicollinearity** (dependencies between predictor variables):

| | TV | Radio | Newspaper | Sales |
| :--- | :---: | :---: | :---: | :---: |
| **TV** | 1.000 | 0.055 | 0.057 | **0.901** |
| **Radio** | 0.055 | 1.000 | 0.354 | **0.350** |
| **Newspaper** | 0.057 | 0.354 | 1.000 | **0.158** |
| **Sales** | **0.901** | **0.350** | **0.158** | 1.000 |

* **Independence of TV:** TV spend is independent of Radio ($r = 0.055$) and Newspaper ($r = 0.057$), indicating no co-budgeting pattern between TV and print/audio.
* **Radio-Newspaper Collinearity:** Radio and Newspaper share a moderate correlation ($r = 0.354$). Markets spending heavily on Radio often spend heavily on Newspaper as well.
* **Regression Implications:** Low overall inter-channel collinearity confirms that linear regression can cleanly isolate individual channel efficiencies ($\beta$ coefficients) without major variance inflation issues.


## Evaluating linear relationships between channel spend and sales:
| Channel | TV | Radio | Newspaper | Sales |
| :--- | :--- | :--- | :--- | :--- |
| **Correlation with Sales ($r$)** | 0.9012 | 0.3496 | 0.1580 | 1.0000 |

* **TV vs. Sales ($r = 0.901$):** Strong positive correlation, indicating TV is the primary driver of sales.
* **Radio vs. Sales ($r = 0.350$):** Moderate positive correlation.
* **Newspaper vs. Sales ($r = 0.158$):** Weak correlation, suggesting lower direct efficiency.
* **Inter-channel Correlation:** TV and Radio show near-zero correlation ($r = 0.055$), whereas Radio and Newspaper show moderate collinearity ($r = 0.354$).

  ## Phase 2: Regression Modeling

### Model Specification
We fit a Multiple Linear Regression model predicting `Sales` based on advertising expenditure across all three media channels:

$$\text{Sales} = \beta_0 + \beta_1 (\text{TV}) + \beta_2 (\text{Radio}) + \beta_3 (\text{Newspaper}) + \epsilon$$

### Fitted Regression Results

| Parameter | Coefficient ($\beta$) | Std. Error | $t$-stat | $p$-value | Significance |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Intercept ($\beta_0$)** | 4.6251 | 0.3075 | 15.041 | $< 0.001$ | *** |
| **TV ($\beta_1$)** | 0.0544 | 0.0014 | 39.592 | $< 0.001$ | *** |
| **Radio ($\beta_2$)** | 0.1070 | 0.0085 | 12.604 | $< 0.001$ | *** |
| **Newspaper ($\beta_3$)** | 0.0003 | 0.0058 | 0.058 | 0.954 | Insignificant |

* **Multiple $R^2$:** 0.9026
* **Adjusted $R^2$:** 0.9011
* **Residual Standard Error:** 1.662 (196 DF)
* **$F$-statistic:** 605.4 ($p < 2.2 \times 10^{-16}$)

### Statistical Insights & LP Optimization Implications
1. **Radio delivers highest marginal return ($\beta_2 = 0.1070$):** Dollar-for-dollar, Radio generates roughly twice the return of TV in this linear model.
2. **TV is strong & reliable ($\beta_1 = 0.0544$):** TV drives massive total volume due to higher spend capacity, maintaining strong statistical significance.
3. **Newspaper is ineffective ($\beta_3 = 0.0003, p = 0.954$):** Newspaper's coefficient is statistically indistinguishable from zero. In the LP optimization phase, Newspaper spend will yield virtually no objective function gain.
 ## Phase 3: Baseline Budget & Mathematical Formulation

### Current Baseline Allocation vs. Expected Performance
Using mean historical market spending as our reference baseline budget ($B = 200.8605$), the current budget allocation yields the following baseline performance:

| Channel | Current Mean Spend ($x_i$) | Current Share (%) | Marginal Return ($\beta_i$) |
| :--- | :--- | :--- | :--- |
| **TV ($x_1$)** | 147.0425 | 73.2% | 0.0544 |
| **Radio ($x_2$)** | 23.2640 | 11.6% | 0.1070 |
| **Newspaper ($x_3$)** | 30.5540 | 15.2% | 0.0003 |
| **Total ($B$)** | **200.8605** | **100.0%** | **Baseline Expected Sales: 15.132** |

---

### Linear Programming (LP) Formulation

We formulate the advertising spend allocation as a continuous Linear Program to maximize total expected sales.

#### Decision Variables
* $x_1$: Expenditure on TV advertising ($\text{in } \$1,000\text{s}$)
* $x_2$: Expenditure on Radio advertising ($\text{in } \$1,000\text{s}$)
* $x_3$: Expenditure on Newspaper advertising ($\text{in } \$1,000\text{s}$)

#### Objective Function
Maximize expected sales ($S$):
$$\max S(x_1, x_2, x_3) = 4.6251 + 0.0544 x_1 + 0.1070 x_2 + 0.0003 x_3$$

*(Note: Since the intercept $4.6251$ is constant, maximizing $S$ is equivalent to maximizing $\beta_1 x_1 + \beta_2 x_2 + \beta_3 x_3$.)*

#### Constraints
 **Total Budget Constraint:**
   $$x_1 + x_2 + x_3 \le 200.8605$$
   
 **Channel Capacity / Upper Bound Constraints (Max Historical Spend):**
   $$x_1 \le 296.40 \quad (\text{TV Max})$$
   $$x_2 \le 49.60 \quad (\text{Radio Max})$$
   $$x_3 \le 114.00 \quad (\text{Newspaper Max})$$
   
 **Non-Negativity Constraints:**
   $$x_1 \ge 0, \quad x_2 \ge 0, \quad x_3 \ge 0$$
