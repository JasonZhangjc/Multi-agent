function [fOr,phi] = getOr7(formula,args,k)

global Mw Z1 zLoop ZLoop bigM epsilon W1 Z1 W2 Z2 W;

% a binary variable for each argument
z = [];

% Constraints
fOr = [];

% number of arguments
m = length(args);

for i=1:m
    if ischar(args{i}) 			            
        % Get its constraints
        [fAP,phiAP] = getLTL7(args{i},k);        
        fOr = [fOr, fAP];
        z = [z;phiAP];
    else                    	                % if argument is counting proposition
        % sdpvar
        ztemp = [getZ7(args{i},k)];           
        z = [z;ztemp];
        % state
        wi = args{i}(1:end-1);
        % threshold
        mi = args{i}(end);
        % number of states
        n = length(W{k});
        % constraint
        Q = W{k}*ones(n,1);
        fOr = [fOr, sum(Q(wi))>=mi+epsilon-bigM*(1-z(i))];
        fOr = [fOr, sum(Q(wi))<=mi-epsilon+bigM*z(i)-1];
    end
end

if m > 1
    % a binary variable for formula
    phi = getZ7(formula,k,1);
    % conjunction constraint
    fOr = [fOr, repmat(phi,m,1)>=z, phi<=sum(z)];
else
    phi = z;
end