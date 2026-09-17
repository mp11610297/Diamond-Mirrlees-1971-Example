% File: find_q1_feasible_range.m
% ------------------------------------------------------------------
% Identifies the range of q1 values that yield a feasible q2 satisfying both
% the government budget constraint and the labor market clearing condition.
%
% For each q1 on a grid, the function:
%   1. Solves for q2 such that the budget constraint residual is zero.
%   2. Checks if total labor supply equals labor demand.
%   3. Records (q1, q2) pairs that satisfy both constraints.
%
% Inputs:
%   R         — redistribution level per household
%   gamma     — risk aversion parameter
%   alpha     — production elasticity parameter
%   plot_flag — (optional, default = true) whether to plot feasibility diagrams
% ------------------------------------------------------------------

function [q1min, q1max, q2min, q2max, q1feas, q2feas] = find_q1_feasible_range(R, gamma, alpha, plot_flag)
    global TOL;
    if isempty(TOL)
        TOL = 1e-6;
    end

    if nargin < 4
        plot_flag = true;
    end

    q1vals = linspace(0.1, 2, 10000);  
    feasible_flags = zeros(size(q1vals));  
    q2sols = nan(size(q1vals));     

    for i = 1:length(q1vals)
        q1 = q1vals(i);
        f = @(q2) budget_residual_qs(q1, q2, R, gamma, alpha);

        try
            % Step 1: maximize budget residual
            q2max = fminbnd(@(q2) -f(q2), 0.01, 5); 
            q2min = 0.01;  

            % Step 2: check sign change and solve
            if sign(f(q2min)) ~= sign(f(q2max))
                q2sol = fzero(f, [q2min, q2max]);

                l1 = compute_labor(q1, gamma);
                l2 = compute_labor(q2sol, gamma);
                lhs = l1 + l2;

                x1 = compute_consumption(q1, R, gamma);
                x2 = compute_consumption(q2sol, R, gamma);
                rhs = (x1^alpha + x2^alpha)^(1/alpha);

                gap = abs(lhs - rhs);

                if gap < TOL
                    feasible_flags(i) = 1;
                    q2sols(i) = q2sol;
                end
            end
        catch
            continue;
        end
    end

    q1feas = q1vals(feasible_flags == 1); 
    q2feas = q2sols(feasible_flags == 1);

    if plot_flag
        figure;
        plot(q1vals, feasible_flags, 'ko-', 'LineWidth', 1.5);
        xlabel('q_1');
        ylabel('Feasibility (1 = root found)');
        title('Feasibility of Solving for q_2 Given q_1');
        grid on;

        figure;
        plot(q1feas, q2feas, 'b.-');
        xlabel('q_1');
        ylabel('Solved q_2');
        title('q_2 Solutions Corresponding to Feasible q_1');
        grid on;
    end

    if isempty(q1feas)
        fprintf('\nNo feasible q1 values found.\n');
        q1min = NaN; q1max = NaN;
        q2min = NaN; q2max = NaN;
    else
        [q2min, indmin] = min(q2feas);
        [q2max, indmax] = max(q2feas(1:indmin));
        q1min = q1feas(indmin);
        q1max = q1feas(indmax);

        fprintf('\nFeasible q1 range:\n');
        fprintf('  q1: [%.4f, %.4f]\n', q1min, q1max);
        fprintf('  q2: [%.4f, %.4f]\n', q2min, q2max);
    end
end