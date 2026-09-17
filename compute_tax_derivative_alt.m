% File: compute_tax_derivative_alt.m
% ------------------------------------------------------------------
% Computes the numerical derivative using a forward difference approximation with respect to q1,
% holding q2 fixed. This is done by evaluating the change in the budget
% residual function when q1 is perturbed by a small amount h.
%
% Inputs:
%   q1     — consumer price for good 1
%   q2     — consumer price for good 2 (held fixed)
%   R      — redistribution level (per household)
%   gamma  — risk aversion parameter
%   alpha  — production elasticity parameter
%   h      — finite difference step size
% ------------------------------------------------------------------

function dT_dt = compute_tax_derivative_alt(q1, q2, R, gamma, alpha,h)
    b0 = budget_residual_qs(q1,q2,R,gamma,alpha);
    b1 = budget_residual_qs(q1+h,q2,R,gamma,alpha);
    
    dT_dt = (b1 - b0) / h;
end