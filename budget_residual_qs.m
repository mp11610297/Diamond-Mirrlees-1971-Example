% File: budget_resdiual_qs
% ------------------------------------------------------------------
% Computes the residual from the government budget constraint 
% given consumer prices q1, q2 and redistribition level R.
%
% Inputs:
%   q1     — consumer price for household A
%   q2     — consumer price for household B
%   R      - redistribiution level (per household)
%   gamma  — risk aversion parameter
%   alpha  — production elasticity parameter
%
% Output:
%   res — residual from the budget constraint:
%         res = t1 * x1 + t2 * x2 - 2R
%         should be zero at equilibrium
% ------------------------------------------------------------------
function res = budget_residual_qs(q1, q2, R, gamma, alpha)
    x1 = compute_consumption(q1, R, gamma);
    x2 = compute_consumption(q2, R, gamma);
    
    t1 = q1 - (1 + (x2 / x1)^alpha)^((1 - alpha) / alpha);
    t2 = q2 - (1 + (x1 / x2)^alpha)^((1 - alpha) / alpha);
    
    res = t1 * x1 + t2 * x2 - 2 * R;
end
