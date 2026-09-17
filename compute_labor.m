% File: compute_labor.m
% ------------------------------------------------------------------
% Computes labor supply for a household given the consumer price and
% the risk aversion parameter gamma.
%
% Inputs:
%   q      — consumer price for the good
%   gamma  — risk aversion parameter 
%
% Output:
%   l        labor supply:
% ------------------------------------------------------------------
function l = compute_labor(q, gamma)
    l = q^(1 / (1 - gamma));
end