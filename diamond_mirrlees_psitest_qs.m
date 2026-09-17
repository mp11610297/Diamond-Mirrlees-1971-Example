% File: diamond_mirrlees_psitest_qs.m
% ------------------------------------------------------------------
% Tests the round-trip consistency of converting social welfare weight psi_A
% to optimal price q1 and back to psi_A using the Diamond-Mirrlees framework.
%
% Procedure:
%   1. Loops over a range of ψ_A values from 0.1 to 0.9.
%   2. For each psi_A:
%      - Computes q1 using maxwelfR_qs (optimal price for given psi_A).
%      - Solves for q2 such that the budget constraint clears.
%      - Computes tax rates t1 and t2, consumption levels x1 and x2.
%      - Calculates marginal values of government revenue via two methods:
%        forward difference on tax and via budget residual symmetry.
%      - Computes the ratio of social welfare weights from price data.
%      - Converts q1 back to psi_A using q1topsiA, then compares to original.
%   3. Reports and plots the absolute error in round-trip psi_A recovery.
%
% Inputs:
%   None (all parameters are set internally: R = 0, gamma = 2, alpha = 2)
% ------------------------------------------------------------------


function diamond_mirrlees_psitest_qs()
    R = 0;
    gamma = 2;
    alpha = 2;
    h = 1e-8;  
    psi_vals = linspace(0.1, 0.9, 9);
    psi_errors = nan(size(psi_vals));

    fprintf('\npsi → q → psiround-trip consistency test:\n');
    fprintf('%8s | %10s | %10s | %10s\n', 'psi_true', 'q1', 'psi_back', 'Error');
    fprintf('%s\n', repmat('-', 1, 50));

    for i = 1:length(psi_vals)
        psiA_true = psi_vals(i);

        % From psiA → q1
        [~, q1] = maxwelfR_qs(psiA_true, R, gamma, alpha, false);  % pass plot_flag = false
        q2 = find_q2_given_q1_bs(q1, R, gamma, alpha, h);

        [t1, t2] = compute_tax(q1,q2,R,gamma,alpha);

        % === Compute equilibrium consumptions  ===
        x1 = compute_consumption(q1, R, gamma);
        x2 = compute_consumption(q2, R, gamma);

        dT_dt1 = compute_tax_derivative(t1, q1, R, gamma, h);
        dT_dt1_alt = compute_tax_derivative_alt(q1,q2,R,gamma,alpha,h); 
        dT_dt2 = compute_tax_derivative(t2, q2, R, gamma, h);
        dT_dt2_alt = compute_tax_derivative_alt(q2,q1,R,gamma,alpha,h); % uses symmetry of budget to switch roles of 1 and 2.  
        z = (dT_dt1 / dT_dt2) * (x2 / x1); % ratio of *money-metric* social welfare weights
        zutil = z*(q1/q2);
        psirat = psi_vals(i)/(1-psi_vals(i));


        % From q1 → psiA_back
        [q2test, psiA_back, ~] = q1topsiA(q1, R, gamma, alpha, h);
        % error
        psi_error = abs(psiA_back - psiA_true);
        psi_errors(i) = psi_error;

        fprintf('%8.4f | %10.4f | %10.4f | %10.2e\n', ...
                psiA_true, q1, psiA_back, psi_error);
    end

    % plot the error
    figure;
    plot(psi_vals, psi_errors, 'o-','LineWidth',1.5);
    xlabel('\psi_A (true)');
    ylabel('|\psi_{A,true} - \psi_{A,back}|');
    title('Round-Trip Consistency Error: \psi \rightarrow q \rightarrow \psi');
    grid on;
end
