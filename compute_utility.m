% File: compute_utility.m
% ------------------------------------------------------------------
% Computes utility for a household given price, redistribution level,
% and risk aversion parameter.
%
% Inputs:
%   q      — consumer price
%   R      — redistribution level (per household)
%   gamma  — risk aversion parameter
%
% Output:
%   u      — utility level of the household
% ------------------------------------------------------------------
function u = compute_utility(q, R, gamma)
    x = compute_consumption(q, R, gamma);
    l = compute_labor(q, gamma);
    u = x - (1 / gamma) * l^gamma;
end