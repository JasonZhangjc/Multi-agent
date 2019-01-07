function fDyn = getRes(A,CA_flag)
% returns dynamical constraints           
global W NW NM;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;
cs = [1 6 31];

R = [10 10 10 10 10 10];

fRes = [];
for n = 1:N
    for t = 1:h
        position = find(W{n}(:,t));
        if(~isempty(find(cs==position)))
            R(n) = R(n) - 1;
        else
            R(n) = 10;
        end
    end
end
fRes = [fRes, R

fDyn = [];
for n = 1:N
    fDyn = [fDyn, sum(W{n}) == ones(1,h+1)];
    others = find([1:N]~=n);
    for i = 2:h+1
        wnext = W{n}(:,i);
        wcurrent = W{n}(:,i-1);
        %fDyn = [fDyn, sos1(wnext,ones(I,1))];
        % move according to adj matrix           
        fDyn = [fDyn, wnext <= A*wcurrent];
        if CA_flag
            for other = 1:N-1
                wother_current = W{others(other)}(:,i-1);
                % fDyn = [fDyn, wnext <= ones(size(I))-wother_current];                
                fDyn = [fDyn, wcurrent <= ones(size(I))-wother_current];
            end
        end
        % conservation of mass                
        %fDyn = [fDyn, sum(W{n}(:,i-1))==1];
        % non-negative number of agents      
        %fDyn = [fDyn, wnext >= zeros(I,1)];
    end
end


