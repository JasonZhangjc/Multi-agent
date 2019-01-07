function fLoop= getLoop7()
% returns loop constraints            % 返回循环变量，就是suffix部分�?

% ֱ���� N ˵���������Ե�ѭ��Լ��

global W BIGM zLoop ZLoop W1 W2;
% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

% Loop variables
    % zLoop(i)=1 where loop starts
    zLoop = binvar(h,1);
    % ZLoop(i)=1 for all i in loop
    ZLoop = zLoop;
% Loop constraints
fLoop = sum(zLoop)==1;

for i = 1:h
    for n = 1:N
        fLoop = [fLoop, W{n}(:,h+1) <= W{n}(:,i) + BIGM*(1-zLoop(i))*ones(I,1)];
        fLoop = [fLoop, W{n}(:,h+1) >= W{n}(:,i) - BIGM*(1-zLoop(i))*ones(I,1)];
    end
    ZLoop(i) = sum(zLoop(1:i));
end

