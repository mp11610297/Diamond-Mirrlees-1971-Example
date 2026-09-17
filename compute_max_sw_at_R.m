% File: compute_max_sw_at_R.m
% ------------------------------------------------------------------
% Computes the maximum social welfare at a given redistribution level R
% by optimizing over feasible q1 values and solving for corresponding q2.
%
% Inputs:
%   R      — redistribution level (per household)
%   psiA   — welfare weight on household A
%   gamma  — risk aversion parameter
%   alpha  — production function parameter
%
% Outputs:
%   sw        — maximum attainable social welfare at given R
%   q1_star   — optimal consumer price for household A
%   q2_star   — corresponding price for household B 
%
% Method:
%   Uses bounded optimization over q1 ∈ [q1min, q1max] and solves for q2 
%   that satisfies equilibrium. 
% ------------------------------------------------------------------
function [sw, q1_star, q2_star] = compute_max_sw_at_R(R, psiA, gamma, alpha)
    global TOL;

    [q1min, q1max, ~, ~, ~, ~] = get_feasible_q1_range(R, gamma, alpha);

    if isnan(q1min) || isnan(q1max)
        sw = -Inf;
        q1_star = NaN;
        q2_star = NaN;
        return;
    end

    % maximize social welfare over feasible q1
    objective = @(q1) -social_welfare(q1, psiA, R, gamma, alpha);
    [q1_star, neg_sw] = fminbnd(objective, q1min, q1max, optimset('TolX', TOL));

    % recover q2 and final welfare
    q2_star = find_q2_given_q1_bs(q1_star, R, gamma, alpha, TOL);
    sw = -neg_sw;
end