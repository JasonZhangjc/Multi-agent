function [fX,phiX] = getBXA(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon Z1 Z2 W1 W2 W;

if length(args)~=1
    disp('X(next) takes a single argument');
    assert(length(args)==1);
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

% % number of states
% n = length(Mw{1});
% 
% % time horizon
% h = length(Mw);
if k < length(Mw)
    % phi2 
    [fX,phiX] = getLTL7(args{1},k+1);    
else   
    %constraints
    fX = [];  
    % And(zLoop_i, args{1}_i)
    zAnd = [];   
    
    for i=1:k   
       phi_i = getZ7(args{1},i,1);
       formulaAnd = strcat('And(', ...
                    'zLoop', '[',num2str(i),'],', ...
       num2str(args{1}), '[',num2str(i),'])');
       zAnd_i = getZ7(formulaAnd,1,1);
       zAnd = [zAnd;zAnd_i];
       
       fX = [fX, zAnd(i)<=phi_i, zAnd(i)<=zLoop(i), zAnd(i)>=phi_i+zLoop(i)-1];      
    end

    % finally (13)
    phiX = getZ7(formula,k,1);
    fX = [fX, repmat(phiX,k,1)>=zAnd, phiX<=sum(zAnd)];
    
end
    