function [fOr,phi] = getOrI(formula,args,k)

global W Wtotal Z zLoop ZLoop bigM epsilon;

% number of agents
N = length(W);
% time horizon
h = size(W{1},2)-1;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fOr = [];

% number of arguments
m = length(args);

for i=1:m
    if ischar(args{i})                	% If argument is a formula
        % Get its constraints
        [fAP,phiAP] = getLTL(args{i},k);
        fOr = [fOr, fAP];
        z = [z; phiAP];
    else 								% if argument is atomic proposition
        % states
        wi = args{i};
        ztemp = getZ(args{i},h,N);
        z = [z; ztemp(k,:)];
        for n = 1:N
            fOr = [fOr, sum(W{n}(wi,k))>=1+epsilon-bigM*(1-z(end,n))];
            fOr = [fOr, sum(W{n}(wi,k))<=1-epsilon+bigM*z(end,n)-1];
        end
    end
end

if m > 1
    % a binary variable for each agent
    phi2 = getZ(formula,h,N);
    % Robust version
    phi = getZ(strcat('Robust(', formula, ')'),h,N);    % disjunction constraint
    for n = 1:N
        fOr = [fOr, repmat(phi(k,n),m,1)>=z(:,n), phi(k,n)<=+sum(z(:,n))];
    end
else
    phi = z;
end