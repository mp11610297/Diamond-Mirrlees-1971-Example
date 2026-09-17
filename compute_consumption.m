% File: compute_consumption.m
% ------------------------------------------------------------------
% Computes the consumption level for a household given the consumer price,
% redistribution level, and risk aversion parameter.
%
% Inputs:
%   q      — consumer price for the good
%   R      — redistribution level 
%   gamma  — risk aversion
%
% Output:
%   x      — optimal consumption level
% ------------------------------------------------------------------
function x = compute_consumption(q, R, gamma)
    x = R ./ q + q.^(gamma / (1 - gamma));
end
