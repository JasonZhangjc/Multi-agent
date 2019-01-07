function [fGG,phi] = getGG7(formula,args,k)

global W Wtotal Z1 zLoop ZLoop bigM epsilon W1;

if length(args)>1
    disp('GG takes a single argument');
    asset(length(args)==1);
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

fGG = [];
z = [];
for k = 1:h
    % Get its constraints
    [fAP,phiAP] = getLTL7(args{1},k);
    fGG = [fGG, fAP];
    z = [z; phiAP];
end

phi = binvar(1);
Z1{length(Z1)+1} = {phi,formula};
% conjunction constraint
fGG = [fGG, repmat(phi,h,1)<=z, phi>=1-h+sum(z)];
