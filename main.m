function main
% === Parameters ===
psiA = 3/4;
alpha = 3;
gamma = 2; 
h=1e-6; 
Rlow = -.03;
Rhigh = -.02;

global TOL;
TOL = 1e-8; 

% === Optimal distribution level ===
Ropt = binaryr(psiA,gamma,alpha,Rlow,(Rlow+Rhigh)/2,Rhigh,h);

% ==== Optimal Prices, Quantities, and taxes ===
[~,q1star,~,~] = maxwelfR_qs(psiA, Ropt, gamma, alpha, false); 
q2star = find_q2_given_q1_bs(q1star, Ropt, gamma, alpha, h);

[t1star,t2star] = compute_tax(q1star,q2star,Ropt,gamma,alpha);

x1star = compute_consumption(q1star,Ropt,gamma); 
x2star = compute_consumption(q2star,Ropt,gamma); 

% === Budget Check ===
testme = budget_residual_qs(q1star,q2star,Ropt,gamma,alpha); % diagnostic to ensure budget balance

% === Derivative Calculations ===

dTdq1 = compute_tax_derivative(t1star,q1star,Ropt,gamma,h); % derivative of revenue with respect to q1, holding q2 constant 
dTdq2 = compute_tax_derivative(t2star,q2star,Ropt,gamma,h); % derivative of revenue with respect to q2, holding q1 constant 
dUAdq1 = x1star; % utility effect of a unit increase in q1 on A's utility, in money metric terms (using envelope theorem: hold x1 fixed, dq_1 just makes A poorer by x1*dq1;
dUBdq2 = x2star; % ditto for household B 

% ==== Jacobians ==== 

J = jacob(q1star,q2star,Ropt,gamma,alpha,h); % gives general equilibrium crosswalk between changes in q and changes in policy t 
J = J'; % so it's in the form dt = J dq with dt and dq column vectors
H = inv(J); %  so dq = H dt, 

% === Revenue Effects of R === 
dTdR = -(budget_residual_qs(q1star,q2star,Ropt+h,gamma,alpha)-budget_residual_qs(q1star,q2star,Ropt,gamma,alpha))/h; % budget effects of an increase in R holding q fixed (including behavioral responses)



%% diagnostics on welfare weights: 
psiAbylam = ((x1star/q1star)/dTdq1)^(-1);
psiBbylam=((x2star/q2star)/dTdq2)^(-1);
[psiAbylam/psiBbylam, psiA/(1-psiA)];  % should match if code is working 

psiAtilde = psiA/q1star; % money metric welfare weights (social value of \$1 to household A)
psiBtilde = (1-psiA)/q2star; % money metric welfare weights (social value of \$1 to household B)
lambdaA = psiAtilde*x1star/dTdq1; % social marginal value of government revenue
lambdaB = psiBtilde*x2star/dTdq2; % ditto -- can test if equal

%% 





% Output is welfare-relevant effects of changes in q1 (first column) and q2 (second) 
Outputq = [dTdq1, dTdq2]; % revenue effects, 
Outputq = [Outputq; dUAdq1, 0; 0, dUBdq2]; % utility effects on A; utility effects on B
Outputt = Outputq * H; % Same things, but now effects of change in t1 and t2
Outputq = [Outputq;(Outputq(1,1:2) - dTdR*Outputq(3,1:2))./(Outputq(2,1:2)-Outputq(3,1:2))]; % critical marginal social value of welfare weight on A type (relative to social MU of government revenue) for which policmaker is indifferent to change in q; uses psiAtilde+psiBtilde = dT/dR relation
Outputt = [Outputt;(Outputt(1,1:2) - dTdR*Outputt(3,1:2))./(Outputt(2,1:2)-Outputt(3,1:2))]; % critical marginal social value of welfare weight on A type (relative to social MU of government revenue) for which is indiffernt to change in t; uses psiAtilde+psiBtilde = dT/dR relation

Outputq = [Outputq; J]; % "effects" on taxes 

Outputt = [Outputt; H]; % "effects" on q 


% === Display Results ===

disp('--- Optimal Parameters ---');
disp(['R*: ', num2str(Ropt)]);
disp(['q1*: ', num2str(q1star), ', q2*: ', num2str(q2star)]);
disp(['t1*: ', num2str(t1star), ', t2*: ', num2str(t2star)]);
disp(['x1*: ', num2str(x1star), ', x2*: ', num2str(x2star)]);
disp(['Budget residual (should be ~0): ', num2str(testme)]);

disp('--- Derivatives ---');
disp(['dT/dq1: ', num2str(dTdq1), ', dT/dq2: ', num2str(dTdq2)]);
disp(['dUA/dq1: ', num2str(dUAdq1), ', dUB/dq2: ', num2str(dUBdq2)]);
disp(['dT/dR: ', num2str(dTdR)]);

disp('--- Welfare Diagnostics ---');
disp(['ψA/λ: ', num2str(psiAbylam), ', ψB/λ: ', num2str(psiBbylam)]);
disp(['ψA/ψB: ', num2str(psiAbylam/psiBbylam), ' (target: ', num2str(psiA/(1 - psiA)), ')']);
disp(['λA: ', num2str(lambdaA), ', λB: ', num2str(lambdaB)]);

disp('--- Output Effects in q-space ---');
disp(Outputq);

disp('--- Output Effects in t-space ---');
disp(Outputt);



end
