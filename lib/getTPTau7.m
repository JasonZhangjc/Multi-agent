function [fTP,phi] = getTPTau7(formula, args, k)

global W Wtotal Z1 bigM tau zLoop NW W1;

if length(args) ~= 2
    disp('Missing argument');
    asset(length(args)==2);
end

% number of agents
N = length(W);
% time horizon
h = size(W{1},2)-1;

r = getZ7(strcat('Robust( ', formula, ')'), h, NW);
% All constraints created in this function
fTP = [];
% set of all ztilde in paper
zTilde = [];
if k==1 || tau ==0
    [fTP, zTP] = getLTL7(args{1},k);
    fTP = [fTP, r(k,:) == zTP];
else
    [fTPk, ztilde] = getLTL7(args{1},k);
    fTP = [fTP, fTPk];
    zTilde = [zTilde; ztilde];
    
    for t = 1:tau
        if t+k <= h
            % If t+k <= h no need to loop around
            ztilde = getZ7(args{1},1,NW);
            ztilde = ztilde(t+k,:);
            zTilde = [zTilde; ztilde];
        else
            % Loop around
            % z^{\args{1},n}_t for all t,n
            zAll =  getZ7(args{1},0,0);
            % ztilde_{k+t} (one for each agent)
            ztilde = getZ7(strcat('~(',num2str(args{1}),')[',num2str(k),',',num2str(t),']'),1,NW);
            % Add to all set of all ztilde
            zTilde = [zTilde; ztilde];
            % Or(z^{args{1},n}_{l+k+t-h-1},1-zLoop_{l})
            zOr = getZ7(strcat('Or(',num2str(args{1}),', Neg(zLoop))[',num2str(k),',',num2str(t),']'),h-t,NW);
            for l = 1:h-t
                for n = 1:NW
                    fTP = [fTP, zOr(l,n)>=1-zLoop(l), zOr(l,n)>=zAll(l+t+k-h-1,n),...
                        zOr(l,n)<= 1-zLoop(l)+zAll(l+t+k-h-1,n)]; 
                end
            end
            % ztilde = And(zOr)
            for n = 1:NW
                fTP = [fTP, ...
                repmat(ztilde(n),h-t,1) <= zOr(:,n),...
                ztilde(n) >= 1-(h-t)+sum(zOr(:,n))];     
            end

        end
    end
    
    % robustified version
    %r = getZ(strcat('Robust( ', formula, ')'), h, N);
    for n = 1:NW
        fTP = [fTP, repmat(r(k,n),tau+1,1)<= zTilde(:,n), r(k,n) >= sum(zTilde(:,n))-tau];
    end
end
    
phi = getZ7(formula,h,1);
phi = phi(k);

fTP = [fTP, sum(r(k,:)) >= args{2} - bigM*(1-phi)];
fTP = [fTP, sum(r(k,:)) <= args{2} + bigM*phi-1];
