function fInit = getInit7(W0,M0)
global W NW NM W1 W2;

% number of agents
N = length(W);
% number of states 
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

for n = 1:NW
    W{n}(:,1) = W0(:,n);
end

for n = 1:NM
    W{n+NW}(:,1) = M0(:,n);
end

fInit = [];                                      