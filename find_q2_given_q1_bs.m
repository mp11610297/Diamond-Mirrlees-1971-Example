% File: find_q2_given_q1_bs.m
% ------------------------------------------------------------------
% Solves for q2 given q1 using binary search, ensuring that the
% government budget constraint is satisfied.
%
% Inputs:
%   q1     — consumer price for good 1
%   R      — redistribution level (per household)
%   gamma  — risk aversion parameter
%   alpha  — production function parameter
%
% Output:
%   q2     — value of q2 such that the budget residual is (approximately) 0
%
% Method:
%   - First checks whether budget residual is positive or negative at q2 = q1.
%   - If positive, uses bisection to find a lower q2 bound.
%   - If not, uses fminsearch to identify upper q2 bound.
%   - Then performs binary search between bracketing bounds.
% ------------------------------------------------------------------


function q2 = find_q2_given_q1_bs(q1, R, gamma, alpha, tol)

    if nargin < 5
        global TOL
        if isempty(TOL)
            TOL = 1e-6;
        end
        tol = TOL;
    end

    f = @(q2) budget_residual_qs(q1, q2, R, gamma, alpha);
    negf = @(x) -f(x);
    q2guess = q1; 
    test = 0;

    if f(q2guess) > 0
        q2max = q2guess;
        q2min = 0;
        test = 1;
        while test == 1
            q2guess = (q2max + q2min) / 2;
            if f(q2guess) > 0
                q2max = q2guess;
            else
                q2min = q2guess;
                test = 0;
            end
        end
    else 
        q2min = q2guess;
        [q2max, temp] = fminsearch(negf, q2guess);
        resmax = -temp;
        if resmax < 0
            fprintf('error: no such q2\n');
            test = -1;
            q2 = NaN;
            return;
        end
    end

    while (q2max - q2min > tol)
        q2guess = (q2max + q2min) / 2;
        if f(q2guess) > 0
            q2max = q2guess;
        else
            q2min = q2guess;
        end
    end

    if test ~= -1
        q2 = (q2max + q2min) / 2;
    end
end
