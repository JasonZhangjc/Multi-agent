function [fNeg,phi] = getNeg7(formula,args,k)

global W Wtotal Z1 zLoop ZLoop bigM epsilon NW W1;

if length(args)>1
    disp('Negation takes a single argument');
    assert(length(args)==1);
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

% Get its constraints
[fNeg,z] = getLTL7(args{1},k);

% a binary variable for formula
phi = getZ7(formula,h,1);
phi = phi(k);

% Negation constaint
fNeg = [fNeg, phi == 1-z];