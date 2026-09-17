% File: q1topsiA.m
% ------------------------------------------------------------------
% Computes the welfare weight psi_a and marginal value of government funds (lambda_a)
% from a given q1 by recovering the consistent q2 and using equilibrium conditions.
%
% Inputs:
%   q1     — consumer price for household A
%   R      — redistribution level
%   gamma  — risk aversion parameter
%   alpha  — preference/production parameter
%   h      — step size for numerical differentiation
%
% Outputs:
%   q2     — price for household B that clears the budget
%   psiA   — implied social welfare weight on household A
%   lamA   — marginal social value of government resources 
%
% Method:
%   - Solves for q2 that balances the budget
%   - Computes individual consumptions
%   - Uses numerical derivatives of the tax functions and consumption levels
%     to compute the ratio of marginal utilities and infer psi_a and
%     lambda_a
% ------------------------------------------------------------------

function [q2,psiA,lamA] = q1topsiA(q1,R,gamma,alpha,h)

% === find q2 that balances the budget === 
q2 = find_q2_given_q1_bs(q1, R, gamma, alpha, h);
[t1, t2] = compute_tax(q1,q2,R,gamma,alpha);

% === Compute equilibrium consumptions  ===
x1 = compute_consumption(q1, R, gamma);
x2 = compute_consumption(q2, R, gamma);

% === Ratio and social weights ===
dT_dt1 = compute_tax_derivative(t1, q1, R, gamma, h);
dT_dt2 = compute_tax_derivative(t2, q2, R, gamma, h);
z = (dT_dt1 / dT_dt2) * (x2 / x1); 
z = z*(q1/q2); % multiply by q1/q2 to turn money metric welfare weight ratio to utility metric welfare weight ratio
psiA = z / (1 + z);  % welfare weight on A (normalizing to \psi_A +\psi_B = 1)
lamA = (psiA * x1) / dT_dt1; % marginal social value of government resources
