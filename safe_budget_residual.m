% File: safe_budget_residual.m
% ------------------------------------------------------------------
% Safely evaluates the government budget residual for given (q1, q2).
% Returns a large penalty value (1e6) if evaluation fails or is invalid.
%
% Inputs:
%   q1     — consumer price for household A
%   q2     — consumer price for household B
%   R      — redistribution level
%   gamma  — risk aversion parameter
%   alpha  — preference/production parameter
%
% Output:
%   val    — budget residual (or 1e6 if NaN, Inf, or error encountered)
% ------------------------------------------------------------------


function val = safe_budget_residual(q1, q2, R, gamma, alpha)
    try
        val = budget_residual_qs(q1, q2, R, gamma, alpha);
        if isnan(val) || isinf(val)
            val = 1e6;
        end
    catch
        val = 1e6;
    end
end
