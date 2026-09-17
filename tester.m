function tester


%test that code is correctly computing optimum -- by checking special case
R=0;
psiA = .2; 
gamma = 2;
alpha = 2;

q1start = 3;
q1guess = q1start;
test = 0;
while test == 0
    f = @(q2) budget_residual_qs(q1guess, q2, R, gamma, alpha);
    negf = @(q2) (-1)*f(q2); 
    [~,val] = fminsearch(negf,q1guess); 
    if val < 0 % maximum of budget is positive, so it is feasible to balance the budget at this q1guess 
        q1guess = q1guess+.1;
    else  % exit once we have an upper bound
        test = 1; 
    end
end
qhigh = q1guess; % that's an infeasible q
q1guess = q1start; 
test = 0;
while test == 0
    f = @(q2) budget_residual_qs(q1guess, q2, R, gamma, alpha);
    negf = @(q2) (-1)*f(q2); 
    [~,val] = fminsearch(negf,q1guess); 
    if val < 0 % maximum of budget is positive, so it is feasible to balance the budget at this q1guess 
        test = 1; 
    else
        q1guess = q1guess/2; 
    end
end
qlow = q1guess; 
flow = @(q2) (-1)*budget_residual_qs(qlow, q2, R, gamma, alpha);
fhigh = @(q2) (-1)*budget_residual_qs(qhigh, q2, R, gamma, alpha);
[x, vallow] = fminsearch(flow,qlow);
[y, valhigh] = fminsearch(fhigh,qhigh); 



[~,q1]= maxwelfR_qs(psiA,R,gamma,alpha);
q2 = find_q2_given_q1_bs(q1,R,gamma,alpha,1e-8);
q1test = find_q2_given_q1_bs(q2,R,gamma,alpha,1e-8);
[t1, t2] = compute_tax(q1,q2,R,gamma,alpha);



%[t2alt,q2alt,~] = t1topsiA(t1,R,gamma,alpha,1e-6); % I'm finding that this does not produce the same answers -- I suspect this old one is wrong (and probably has to do with "compute consumption" routine)
p1 = q1+t1;
p2 = q2+t2;
res = budget_residual_qs(q1,q2,R,gamma,alpha);
% I'm finding that I'm not getting good fidelity comparing psiA=1 to psiA=0
% (should be symmetric answers, but they are off at second sig. fig., even with 10k grid points in maxwelfR_qs 
% my guess is that issues in find_q2_given_q1.m 
% a canned/opaque solver

%q1=.8;
%q2vec = linspace(.5,1,100);
%resvec = nan(size(q2vec));
%for i=1:length(q2vec)
%    resvec(i) = budget_residual_qs(q1,q2vec(i),R,gamma,alpha);
%end
%plot(q2vec,resvec)



end
