function [fFG,phi] = getFG8(formula, args, k)

global W Wtotal Z2 zLoop ZLoop bigM2 epsilon W2;

if length(args)>1
    disp('GF takes a single argument')
    return
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

z = [];
fFG = [];

formulaOr = strcat('Or(', ...
        num2str(args{1}),', (1-ZLoop))');
zOr = getZ8(formulaOr,h,1);

for k = 1:h
    [fLTL,zk] = getLTL8(args{1}, k);
    z = [z;zk];
    fFG = [fFG, fLTL];
    % Zi = And(zi,ZLoop)
    fFG = [fFG, zOr(k)>=z(k), zOr(k)>=1-ZLoop(k), zOr(k)<=1-ZLoop(k)+z(k)];
end

phi = getZ8(formula,1,1);

fFG = [fFG, repmat(phi,h,1)<=zOr, phi>=1-h+sum(zOr)];

    