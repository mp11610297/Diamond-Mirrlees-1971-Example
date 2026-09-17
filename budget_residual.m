% File: budget_residual.m
% ------------------------------------------------------------------
% Computes the residual from the government budget constraint 
% using taxes (t1, t2)and redistribution level R.
%
% Inputs:
%   t1     — tax rate for household A
%   t2     — tax rate for household B
%   R      - redistribiution level (per household)
%   gamma  — risk aversion parameter
%
% Output:
%   res — residual from the government budget constraint:
%         res = t1 * x1 + t2 * x2 - 2R
%         should be close to zero at equilibrium
% ------------------------------------------------------------------

function res = budget_residual(t1, t2, R, gamma)
    [q1, q2] = compute_consumer_prices(t1, t2, R, gamma, 2);
    x1 = compute_consumption(q1,R,gamma);
    x2 = compute_consumption(q2,R,gamma);
    res = t1 * x1 + t2 * x2 - 2 * R;
end
