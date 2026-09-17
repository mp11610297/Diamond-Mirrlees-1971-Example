% File: jacob.m
% ------------------------------------------------------------------
% Computes the Jacobian matrix of tax rates with respect to consumer prices.
% Returns the local General Equilibrium relationship between changes in taxes 
% and changes in consumer prices:
%
%     [dt1/dq1, dt1/dq2;
%      dt2/dq1, dt2/dq2]
%
% So, row *i* corresponds to the tax policy changes associated with a change in *qᵢ*
% (i.e., the tax law changes that would be needed to induce a change in the consumer 
% price of one good only, holding other factors constant).
%
% Inputs:
%   q1     — consumer price for household A
%   q2     — consumer price for household B
%   R      — redistribution level
%   gamma  — risk aversion parameter
%   alpha  — production/preference parameter
%   h      — step size for finite difference approximation
%
% Output:
%   J — 2×2 Jacobian matrix as shown above
% ------------------------------------------------------------------


function J = jacob(q1,q2,R,gamma,alpha,h)

[t1,t2] = compute_tax(q1,q2,R,gamma,alpha);
[t1d1, t2d1] =  compute_tax(q1+h,q2,R,gamma,alpha);
[t1d2, t2d2] =  compute_tax(q1,q2+h,R,gamma,alpha);

J = [(t1d1-t1),  (t2d1 -t2); (t1d2-t1),  (t2d2 -t2) ]/h; 