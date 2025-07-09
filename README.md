# Diamond-Mirrlees 1971 Example (MATLAB)

This project encodes a computational model of optimal redistrubution using the 1971 Diamond Mirrlees example. In this scenario, we investigate optimal taxes and welfare objectives in a simplified two-household, two-good economy. Using this model, we are able to illustrate what Saez and Zucman mean when they argue that changes in pre-tax prices are normatively irrelevant. 

## Prerequisites 

To run this code, you will need: 
- MATLAB R2020b or later
- Optimization Toolbox 

## Installing 

In order to set up the project, follow these steps: 

1. Download the project repository to your device, and ensure that the working directory accesses the folder containing the project files. 
2.  In the command window, type "main" to run the `main.m` script. If you wish to change any parameters, this may be done in the `main.m` script. 

After a successful run, the `main.m` script will output

- Optimal redistribution level `Ropt`
- Optimal consumer prices `q1`, `q2`
- Corresponding taxes `t1`, `t2`, and consumptions `x1`, `x2`
- Utility diagnostics and marginal value of government resources, `λ`


## File Organization

### Executables

- `main.m` — Primary execution script. Computes optimal redistribution and diagnostics.
- `binaryr.m` — Finds the optimal redistribution level `R*` that maximizes social welfare using a binary search.


### Core Model Logic

- `maxwelfR_qs.m` — Solves for the `q1` that maximizes social welfare at a given redistribution level `R`.
- `compute_max_sw_at_R.m` — Computes the optimal `q1`, `q2`, and welfare for a fixed `R`.
- `social_welfare.m` — Evaluates social welfare for given `q1` and `R`.
- `find_q2_given_q1_bs.m` — Solves for `q2` given `q1` via binary search to satisfy the budget constraint.

### Supporting Functions

- `compute_consumption.m` — Computes consumption given price, redistribution, and risk aversion.
- `compute_labor.m` — Computes labor supply given consumer prices and preferences.
- `compute_tax.m` — Computes taxes `t1`, `t2` given consumer prices and parameters.
- `compute_utility.m` — Computes utility given price and parameters.
- `compute_consumer_prices.m` — Solves for consumer prices `q1`, `q2` given taxes and parameters.
- `compute_tax_derivative.m` / `compute_tax_derivative_alt.m` — Compute numerical derivatives of tax revenue.
- `jacob.m` — Approximates Jacobian matrix of price-to-tax relationships.

### Diagnostics and Tests

- `diamond_mirrlees_psitest_qs.m` — Tests round-trip consistency from `ψ_A → q₁ → ψ_A`.
- `maxwelf_over_R.m` — Plots maximum social welfare as a function of redistribution `R`.
- `find_q1_feasible_range.m` / `get_q1_at_min_q2.m` — Identifies feasible price ranges under constraints.
- `q1topsiA.m` / `t1topsiA.m` — Infers welfare weights and `λ` from observed prices or taxes.
- `budget_residual.m` / `budget_residual_qs.m` / `safe_budget_residual.m` — Budget constraint enforcement tools.
- `main.m` — Stress-test of equilibrium and budget mapping functions.


## Tolerance
A centralized tolerance variable can be declared in a main script:
```matlab
global TOL;
TOL = 1e-8;
```
Use `TOL` in all functions requiring convergence accuracy.

## Running the Tests

### Round Trip Tests

Run the consistency test:

```matlab
diamond_mirrlees_psitest_qs();
```

This verifies:

- Forward and reverse consistency of the mapping `ψ_A ↔ q₁`
- Budget balance and labor market clearing

## Known Issues

- Certain parameter combinations may result in flat residuals near the root, which can affect convergence.
- Accuracy of round-trip mappings can degrade when `ψ_A` is very close to 0 or 1.




 
