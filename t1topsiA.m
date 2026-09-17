% File: t1topsiA.m
% ------------------------------------------------------------------
% Computes the welfare weight psi_A and marginal value of public funds lam_A 
% given a tax rate t1 and equilibrium conditions.
%
% Inputs:
%   t1     — tax rate for household A
%   R      — redistribution level
%   gamma  — risk aversion parameter
%   alpha  — preference/production parameter
%   h      — step size for finite difference derivative
%
% Outputs:
%   t2     — tax rate for household B that balances the budget
%   psiA   — social welfare weight on household A
%   lamA   — marginal value of public funds (dW/dR) for household A
%
% Notes:
%   - Solves for t₂ using fsolve to satisfy the government budget constraint.
%   - Consumer prices (q₁, q₂) are derived from tax rates.
%   - Welfare weights and λ_A are computed from marginal utilities of tax revenue.
% ------------------------------------------------------------------

function [t2, psiA, lamA] = t1topsiA(t1, R, gamma, alpha, h)

    % Set default step size from global tolerance if not provided
    if nargin < 5
        global TOL;
        if isempty(TOL)
            TOL = 1e-6;
        end
        h = TOL;
    end

    % === find t2 that balances the budget === 
    options = optimset('Display', 'off', 'TolFun', 1e-10, 'TolX', 1e-10);
    t2 = fsolve(@(t2) budget_residual(t1, t2, R, gamma), 0, options);

    % === Compute consumer prices at equilibrium ===
    [q1, q2] = compute_consumer_prices(t1, t2, R, gamma, alpha);

    % === Compute equilibrium consumptions  ===
    x1 = compute_consumption(q1, R, gamma);
    x2 = compute_consumption(q2, R, gamma);

    % === Ratio and social weights ===
    dT_dt1 = compute_tax_derivative(t1, q1, R, gamma, h);
    dT_dt2 = compute_tax_derivative(t2, q2, R, gamma, h);
    z = (dT_dt1 / dT_dt2) * (x2 / x1);
    psiA = z / (1 + z);  % welfare weight on A (normalizing to ψ_A + ψ_B = 1)
    lamA = (psiA * x1) / dT_dt1; % marginal social value of government resources
end
