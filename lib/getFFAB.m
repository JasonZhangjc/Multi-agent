function [fFF,phi] = getFFAB(formula, args, k)

global W Wtotal Z2 zLoop ZLoop bigM2 epsilon W2;



if length(args)>1
    disp('FF takes a single argument');
    asset(length(args)==1);
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

zor = [];
fFF = [];
for i = 1:h
    [fLTL,zi] = getLTL8(args{1}, i);
    zor = [zor;zi];
    fFF = [fFF, fLTL];  
end

phi = getZ8(formula, 1,1);

fFF = [fFF, repmat(phi,h,1)>=zor, phi<=sum(zor)];

    