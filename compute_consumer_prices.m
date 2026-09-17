% File: compute_consumer_prices.m
% ------------------------------------------------------------------
% Solves for consumer prices (q1, q2) given taxes (t1, t2), 
% ensuring consistency with the household optimization and 
% production-side tax formulas.
%
% Inputs:
%   t1     — tax rate for household A (on good 1)
%   t2     — tax rate for household B (on good 2)
%   R      — lump-sum redistribution per household
%   gamma  — risk aversion parameter
%   alpha  — production elasticity parameter
%
% Outputs:
%   q1     — consumer price of good 1
%   q2     — consumer price of good 2
%
% Notes:
%   Uses fsolve to solve a system of two nonlinear equations 
%   linking taxes and consumption-based price formulas.
% ------------------------------------------------------------------
function [q1, q2] = compute_consumer_prices(t1, t2, R, gamma, alpha)
guess = [1; 1];
eqns = @(q) [
q(1) - (1 + (compute_consumption(q(2),R,gamma)/compute_consumption(q(1),R,gamma))^alpha)^( (1 - alpha) / alpha ) - t1;
q(2) - (1 + (compute_consumption(q(1),R,gamma)/compute_consumption(q(2),R,gamma))^alpha)^( (1 - alpha) / alpha ) - t2];

[qs, ~, flag] = fsolve(eqns, guess);
if flag <= 0
error('Failed to solve for q1 and q2');
end
q1 = qs(1);
q2 = qs(2);
end
