% File: social_welfare.m
% ------------------------------------------------------------------
% Computes total social welfare for a given consumer price q1 and 
% welfare weight psi_A.
%
% Inputs:
%   q1     — consumer price for household A
%   psiA   — social welfare weight on household A
%   R      — redistribution level
%   gamma  — risk aversion parameter
%   alpha  — preference/production parameter
%
% Output:
%   sw     — total social welfare:
%            sw = psi_A * uA + (1 - psi_A) * uB
%            where utility uA and uB are computed for optimal q1, q2
% ------------------------------------------------------------------
function sw = social_welfare(q1, psiA, R, gamma, alpha)
    q2 = find_q2_given_q1_bs(q1, R, gamma, alpha, 1e-8);
    uA = compute_utility(q1, R, gamma);
    uB = compute_utility(q2, R, gamma);
    sw = psiA * uA + (1 - psiA) * uB;
end
