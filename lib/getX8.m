function [fX,phiX] = getX8(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon Z2 W2 W Z1 W1;

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

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

% if k < length(Mw)
if k < h

    % phi2 
    [fX,phiX] = getLTL8(args{1},k+1);
   
else
    
    %constraints
    fX = [];
    
    % And(zLoop_i, args{1}_i)
    zAnd = [];
    
    for i=1:k
       
       phi_i = getZ8(args{1},i,1);
       
       formulaAnd = strcat('And(', ...
                    'zLoop', '[',num2str(i),'],', ...
       num2str(args{1}), '[',num2str(i),'])');
       zAnd_i = getZ8(formulaAnd,1,1);
       zAnd = [zAnd;zAnd_i];
       
       fX = [fX, zAnd(i)<=phi_i, zAnd(i)<=zLoop(i), zAnd(i)>=phi_i+zLoop(i)-1];
           
    end

    % finally (13)
    phiX = getZ8(formula,k,1);
    fX = [fX, repmat(phiX,k,1)>=zAnd, phiX<=sum(zAnd)];
    
end
    