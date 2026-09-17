% File: compute_tax_derivative.m
% ------------------------------------------------------------------
% Computes the numerical derivative of tax revenue T(t, q) = t * x(q)
% with respect to the tax rate t, using forward finite differences.
%
% Inputs:
%   t      — base tax rate
%   q      — consumer price
%   R      — redistribution level (per household)
%   gamma  — risk aversion parameter
%   h      — small perturbation step size for numerical derivative
% ------------------------------------------------------------------

function dT_dt = compute_tax_derivative(t, q, R, gamma, h)
    x_base = compute_consumption(q,R,gamma);
    q_pert = q + h;
    x_pert = compute_consumption(q_pert,R,gamma); 

    T_base = t * x_base;
    T_pert = (t + h) * x_pert;

    dT_dt = (T_pert - T_base) / h;
end