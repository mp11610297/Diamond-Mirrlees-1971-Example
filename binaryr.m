% file: binaryr.m
% ---------------------------------------------------------------
% Finds the optimal redistribution level R* that maximizes social welfare,
% using a bisection-like search method.
%
% Inputs:
%   psiA  — welfare weight on agent A
%   gamma — risk aversion parameter
%   alpha — production elasticity parameter
%   Requires as input a trio of ``initial guesses'' for R: 
%   Rlow, Rmid, Rhigh — initial bracket guesses such that:
%       Rlow < Rmid < Rhigh and 
%       welfare(Rmid) > max(welfare(Rlow), welfare(Rhigh))
%
% Output:
%   Ropt — estimated R* that maximizes social welfare
% ---------------------------------------------------------------

function Ropt = binaryr(psiA,gamma,alpha,Rlow,Rmid,Rhigh,h)

welflow = maxwelfR_qs(psiA,Rlow,gamma,alpha,false);
welfmid = maxwelfR_qs(psiA,Rmid,gamma,alpha,false);
welfhigh = maxwelfR_qs(psiA,Rhigh,gamma,alpha,false);
Rguess = 0; 
welfguess = 0; 

test = (welfhigh<welfmid)*(welflow<welfmid)*(Rlow<Rmid)*(Rmid<Rhigh);

if test==0
   fprintf('initial values for R are invalid');
   pause;
end

% bisection method for maximum R value
while (Rhigh-Rlow) > h 

if (Rhigh - Rmid) > (Rmid - Rlow)
    Rguess = (Rhigh+Rmid)/2;
    welfguess =  maxwelfR_qs(psiA,Rguess,gamma,alpha,false);
    if welfguess > welfmid
        Rlow = Rmid; 
        welflow = welfmid;
        Rmid = Rguess;
        welfmid = welfguess;
    else
        Rhigh = Rguess; 
        welfhigh = welfguess;
    end
else
    Rguess = (Rlow+Rmid)/2;
    welfguess =  maxwelfR_qs(psiA,Rguess,gamma,alpha,false);
    if welfguess > welfmid
        Rhigh = Rmid; 
        welfhigh = welfmid;
        Rmid = Rguess;
        welfmid = welfguess;
    else
        Rlow = Rguess; 
        welflow = welfguess;
    end
end
end

Ropt = Rmid;


end