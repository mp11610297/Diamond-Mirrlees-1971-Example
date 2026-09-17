% File: get_q1_at_min_q2.m
% ------------------------------------------------------------------
% Finds the q1 that yields the minimum feasible q2 under both the 
% government budget constraint and labor market clearing.
%
% Inputs:
%   R      — redistribution level
%   gamma  — risk aversion parameter
%   alpha  — production/preference parameter
%
% Outputs:
%   q1_at_min_q2 — value of q1 corresponding to minimum feasible q2
%   min_q2       — minimum feasible q2 
% ------------------------------------------------------------------
function [q1_at_min_q2, min_q2] = get_q1_at_min_q2(R, gamma, alpha)
   global TOL;
    if isempty(TOL)
        TOL = 1e-6;
    end

    q1vals = linspace(0.1, 2, 20000);  
    feasible_flags = false(size(q1vals));  
    q2sols = nan(size(q1vals));     

    for i = 1:length(q1vals)
        q1 = q1vals(i);
        f = @(q2) budget_residual_qs(q1, q2, R, gamma, alpha);

        try
            % Find maximum of the residual to use for upper bracket
            q2max_try = fminbnd(@(q2) -f(q2), 0.01, 5); 
            q2min_try = 0.01;  

            if sign(f(q2min_try)) ~= sign(f(q2max_try))
                q2sol = fzero(f, [q2min_try, q2max_try]);

                l1 = compute_labor(q1, gamma);
                l2 = compute_labor(q2sol, gamma);
                lhs = l1 + l2;

                x1 = compute_consumption(q1, R, gamma);
                x2 = compute_consumption(q2sol, R, gamma);
                rhs = (x1^alpha + x2^alpha)^(1/alpha);

                if abs(lhs - rhs) < TOL
                    feasible_flags(i) = true;
                    q2sols(i) = q2sol;
                end
            end
        catch
            continue
        end
    end

    q1feas = q1vals(feasible_flags);
    q2feas = q2sols(feasible_flags);

    if isempty(q2feas)
        warning('get_q1_at_min_q2: No feasible (q1, q2) pair found.');
        q1_at_min_q2 = NaN;
        min_q2 = NaN;
        return;
    end

    [min_q2, indmin] = min(q2feas);
    q1_at_min_q2 = q1feas(indmin);

    fprintf('Found q₁ = %.6f at min feasible q₂ = %.6f\n', q1_at_min_q2, min_q2);
end