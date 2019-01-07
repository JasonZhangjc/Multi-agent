function [fAnd,phi] = getAnd7(formula,args,k)

global W Wtotal Z1 zLoop ZLoop bigM epsilon NW W1;

% number of agents
N = length(W);
% number of states
I = size(W{1},1);           
% time horizon
h = size(W{1},2)-1;          
							 
% m*N binvar: a binary variable for each argument and agent 
z = [];                   

% Constraints
fAnd = [];                

% number of arguments
m = length(args);

for i=1:m
    % Get its constraints
    [fAP,phiAP] = getLTL7(args{i},k);   
    fAnd = [fAnd, fAP];                   
    z = [z; phiAP];                     
end

if m > 1                      
    % a binary variable
    phi = getZ7(formula,h,1);              
    phi = phi(k);
    % conjunction constraint
    fAnd = [fAnd, repmat(phi,m,1)<=z, phi>=1-m+sum(z)];
else
    phi = z;                 
    
end