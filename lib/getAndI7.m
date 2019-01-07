function [fAnd,phi] = getAndI7(formula,args,k)            

global W Wtotal Z1 zLoop ZLoop bigM epsilon NW W1;

% number of agents
N = length(W);
% time horizon
h = size(W{1},2)-1;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fAnd = [];

% number of arguments
m = length(args);

for i=1:m
    if ischar(args{i})                       % If argument is a formula
        % Get its constraints
        [fAP,phiAP] = getLTL7(args{i},k);    
        fAnd = [fAnd, fAP];                
        z = [z; phiAP];                
    else                                     
        % states
        wi = args{i};                    
        ztemp = getZ7(args{i},h,NW);         
        z = [z; ztemp(k,:)];
        for n = 1:NW
            fAnd = [fAnd, sum(W1{n}(wi,k))>=1+epsilon-bigM*(1-z(end,n))];
            fAnd = [fAnd, sum(W1{n}(wi,k))<=1-epsilon+bigM*z(end,n)-1];
        end
    end
end

if m > 1
    % a binary variable for each agent
    phi = getZ7(formula,h,NW);               
    phi = phi(k,:);
    
    % conjunction constraint
	for n = 1:NW
        fAnd = [fAnd, repmat(phi(n),m,1)<=z(:,n), phi(n)>=1-m+sum(z(:,n))];
    end
else
    phi = z;
end
