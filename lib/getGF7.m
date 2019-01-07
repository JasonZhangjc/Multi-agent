function [fGF,phi] = getGF7(formula, args, k)

global W Wtotal Z1 zLoop ZLoop bigM epsilon W1;

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
fGF = [];

formulaAnd = strcat('And(', ...
        num2str(args{1}),', ZLoop)');
zAnd = getZ7(formulaAnd, h, 1);   
% zAnd = binvar(h,1);
% Z{length(Z)+1} = {zAnd,formulaAnd};

for k = 1:h
    [fLTL,zk] = getLTL7(args{1}, k);
    z = [z;zk];
    fGF = [fGF, fLTL];
    % zAnd_k = And(z_k,ZLoop_k)
    fGF = [fGF, zAnd(k)<=z(k), zAnd(k)<=ZLoop(k), zAnd(k)>=ZLoop(k)+z(k)-1];
end

phi = getZ7(formula,1,1);

fGF = [fGF, repmat(phi,h,1)>=zAnd, phi<=sum(zAnd)];

    