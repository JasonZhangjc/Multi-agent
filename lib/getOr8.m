function [fOr,phi] = getOr8(formula,args,k)

global Mw Z2 zLoop ZLoop bigM2 epsilon W2 Z2 W1 Z1 W;

% a binary variable for each argument
z = [];

% Constraints
fOr = [];

% number of arguments
m = length(args);

for i=1:m
    if ischar(args{i}) 			           
        % Get its constraints
        [fAP,phiAP] = getLTL8(args{i},k);        
        fOr = [fOr, fAP];
        z = [z;phiAP];
    else                    	            
        % sdpvar
        ztemp = [getZ8(args{i},k)];   
        z = [z;ztemp];
        % state
        wi = args{i}(1:end-1);
        % threshold
        mi = args{i}(end);
        % number of states
        n = length(W{k});
        % constraint
        Q = Mw{k}*ones(n,1);
        fOr = [fOr, sum(Q(wi))>=mi+epsilon-bigM2*(1-z(i))];
        fOr = [fOr, sum(Q(wi))<=mi-epsilon+bigM2*z(i)-1];
    end
end

if m > 1
    % a binary variable for formula
    phi = getZ8(formula,k,1);
    % conjunction constraint
    fOr = [fOr, repmat(phi,m,1)>=z, phi<=sum(z)];
else
    phi = z;
end