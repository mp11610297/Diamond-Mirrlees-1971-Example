% File: compute_tax.m
% ------------------------------------------------------------------
% Computes the taxes t1 and t2 associated with consumer prices q1 and q2.
%
% Inputs:
%   q1     — consumer price for good 1
%   q2     — consumer price for good 2
%   R      — redistribution level (per household)
%   gamma  — risk aversion parameter
%   alpha  — production elasticity parameter
%
% Outputs:
%   t1     — tax rate on good 1
%   t2     — tax rate on good 2
% ------------------------------------------------------------------
function [t1, t2] = compute_tax(q1, q2, R, gamma, alpha)
    x1 = compute_consumption(q1, R, gamma);
    x2 = compute_consumption(q2, R, gamma);

    t1 = q1 - (1 + (x2 / x1)^alpha)^((1 - alpha) / alpha);
    t2 = q2 - (1 + (x1 / x2)^alpha)^((1 - alpha) / alpha);
end