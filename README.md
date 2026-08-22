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

* **TV vs. Sales ($r = 0.901$):** Strong positive correlation, indicating TV is the primary driver of sales.
* **Radio vs. Sales ($r = 0.350$):** Moderate positive correlation.
* **Newspaper vs. Sales ($r = 0.158$):** Weak correlation, suggesting lower direct efficiency.
* **Inter-channel Correlation:** TV and Radio show near-zero correlation ($r = 0.055$), whereas Radio and Newspaper show moderate collinearity ($r = 0.354$).
