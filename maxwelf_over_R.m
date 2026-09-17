% File: maxwelf_over_R.m
% ------------------------------------------------------------------
% Evaluates and plots maximum social welfare as a function of redistribution R.
% For a fixed psi_A, gamma, and alpha, this function sweeps through a grid of R values,
% computes optimal q1, q2, utilities, and social welfare at each point, and plots results.
%
% Inputs:
%   psiA   — welfare weight on household A
%   gamma  — risk aversion parameter
%   alpha  — production/preference parameter
%
% Behavior:
%   - Calls `maxwelfR_qs` to solve for optimal q1 at each R
%   - Solves for corresponding q₂ using `find_q2_given_q1_bs`
%   - Computes utilities and social welfare
%   - Plots SW as a function of R
% ------------------------------------------------------------------

function maxwelf_over_R(psiA, gamma, alpha)
    % Evaluates and plots max social welfare as a function of R

    Rvec = linspace(-0.03, 0, 9);
    swvec = nan(size(Rvec));
    q1star = nan(size(Rvec));

    for i = 1:length(Rvec)
        R = Rvec(i);
        try
            
            [swvec(i), q1star(i)] = maxwelfR_qs(psiA, R, gamma, alpha, false);

            % Optional diagnostic outputs
            q1 = q1star(i);
            q2 = find_q2_given_q1_bs(q1, R, gamma, alpha, 1e-8);
            uA = compute_utility(q1, R, gamma);
            uB = compute_utility(q2, R, gamma);

            fprintf('R = %.4f | q1 = %.4f | q2 = %.4f | uA = %.4f | uB = %.4f | SW = %.4f\n', ...
                    R, q1, q2, uA, uB, swvec(i));
        catch
            fprintf('R = %.4f | Solver failed, skipping\n', R);
        end
    end

    % Plot valid points
    valid = isfinite(swvec);
    figure;
    plot(Rvec(valid), swvec(valid), 'o-', 'LineWidth', 1.5);
    xlabel('R');
    ylabel('Max Social Welfare');
    title(sprintf('Max Social Welfare vs R (psia = %.2f)', psiA));
    grid on;
end
