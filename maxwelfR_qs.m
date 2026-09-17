% File: maxwelfR_qs.m
% ------------------------------------------------------------------
% Computes the q1 that maximizes social welfare given redistribution R.
% Uses grid search for plotting and ternary search for precise optimum.
%
% Inputs:
%   psiA      — welfare weight on household A
%   R         — redistribution level
%   gamma     — risk aversion parameter
%   alpha     — preference/production parameter
%
% Outputs:
%   maxWelf   — maximum social welfare
%   q1_star   — q1 that maximizes SW
%   q1vec     — grid of q1 values used for plotting
%   swvec     — corresponding social welfare values
% ------------------------------------------------------------------

function [maxWelf, q1_star, q1vec, swvec] = maxwelfR_qs(psiA, R, gamma, alpha, plot_flag)
    if nargin < 5
        plot_flag = true;
    end

    global TOL;
    if isempty(TOL)
        TOL = 1e-6;
    end
    tol = TOL;

    % feasibility-based q1 range from q1 associated with min feasible q2
    [q1max, q1min] = get_q1_at_min_q2(R, gamma, alpha); % CR: changed here 7-3-25
    if isnan(q1max)
        warning('maxwelfR_qs: No feasible q1 found.');
        maxWelf = NaN;
        q1_star = NaN;
        q1vec = [];
        swvec = [];
        return
    end

    % use small increment to stay within feasible interior
    incr = (q1max - q1min) / 100;

    % grid for plotting social welfare
    q1vec = linspace(q1min + incr, q1max - incr, 200);
    swvec = zeros(size(q1vec));
    for i = 1:length(q1vec)
        q1 = q1vec(i);
        try
            q2 = find_q2_given_q1_bs(q1, R, gamma, alpha, tol);
            uA = compute_utility(q1, R, gamma);
            uB = compute_utility(q2, R, gamma);
            swvec(i) = psiA * uA + (1 - psiA) * uB;
        catch
            swvec(i) = -Inf;
        end
    end

    % ternary search for max welfare
    max_iter = 1000;
    iter = 0;

    while (q1max - q1min > tol) && (iter < max_iter)
        q1L = q1min + (q1max - q1min) / 3;
        q1R = q1max - (q1max - q1min) / 3;

        try
            swL = social_welfare(q1L, psiA, R, gamma, alpha);
        catch
            swL = -Inf;
        end
        try
            swR = social_welfare(q1R, psiA, R, gamma, alpha);
        catch
            swR = -Inf;
        end

        if swL > swR
            q1max = q1R;
        else
            q1min = q1L;
        end

        iter = iter + 1;
    end

    q1_star = (q1min + q1max) / 2;
    q2_star = find_q2_given_q1_bs(q1_star, R, gamma, alpha, tol);
    uA = compute_utility(q1_star, R, gamma);
    uB = compute_utility(q2_star, R, gamma);
    maxWelf = psiA * uA + (1 - psiA) * uB;

    % plot
    if plot_flag
        figure;
        plot(q1vec, swvec, 'k-', 'LineWidth', 1.5); hold on;
        plot(q1_star, maxWelf, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
        xlabel('q₁');
        ylabel('Social Welfare');
        title(sprintf('Social Welfare vs q₁ (ψₐ = %.2f)', psiA));
        grid on;
    end
end