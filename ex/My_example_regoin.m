clear;
close all;
clc;
addpath(genpath('../'))

global W Wtotal Z zLoop ZLoop epsilon tau CA_flag bigM bigM2 BIGM NW NM bigM2 W1 W2 Z1 Z2;

%%

% Time horizon
h = 30;    
% robustness number
epsilon = 0;
tau = 0;
t_spec1 = 0;
t_spec2 = 0;


%% Region 1
W = [];
Z = [];
Wtotal = [];
f1 = [];
f2 = [];
f3 = [];
f4 = [];
f5 = [];
f6 = [];
f7 = [];
% define a gridworld
grid_size = [6, 6];
mygrid = ones(grid_size);

% Room 1&2
mygrid(1:5, 1:2) = 0.8;
mygrid(1:5, 4:5) = 0.6;
mygrid(5, 3) = 0.6;

% narrow passage
mygrid(3, 3:4) = 0.4;

% Obstacles
mygrid(1:2, 3) = 0;
mygrid(4, 3) = 0;

% charging station
mygrid(1,1) = 0.2;
mygrid(5,5) = 0.2;

% Deliver spot
mygrid(6,3) = 0.3;
mygrid(3,6) = 0.3;

state_labels = mygrid(:);

CS = find(state_labels(:)==0.2)';
cs = num2str(CS);
DS = find(state_labels(:)==0.3)';
ds = num2str(DS);
Pass = find(state_labels(:)==0.4)';
pass = num2str(Pass);
Room1 = find(state_labels(:)==0.8)';
room1 = num2str(Room1);
Room2 = find(state_labels(:)==0.6)';
room2 = num2str(Room2);
Room3 = find(state_labels(:)==1)';
room3 = num2str(Room3);

% visualization
figure
vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
imshow(kron(vis,ones(25,25)))
% pass_ends = [23,73,Pass];

% spec is the conjunction of the following
Obs = state_labels(:)==0;                   %avoid obstacles

% At most one robot on pass
f1 = strcat('GG(Neg(TP([',pass,'],[2])))');                               
f2 = strcat('GG(TP([',num2str(setdiff(1:36,Pass)),'],[2]))');             

% Populate Room1 and Room2 by at least 2 robots
f3 = strcat('GF(TP([',num2str(Room1),'],[2]))');       
f4 = strcat('GF(TP([',num2str(Room2),'],[2]))');        

% At most 1 robot at the lower zone.   
f5 = strcat('GG(Neg(TP([',num2str(Room3),'],[1])))');     
f6 = strcat('GG(TP([',num2str(setdiff(1:36,Room3)),'],[3]))'); 

% All robots should visit the charging station.
f7 = strcat('TP(GFI([',num2str(CS), ']),[3])');

% Another surveilence task!
f8 = strcat('FG(TP([',num2str(Room1),'],[2]))');       
f9 = strcat('FG(TP([',num2str(Room2),'],[2]))');        

adj = eye(numel(mygrid)); %allow self-transition

for i=1:length(state_labels)
    if mod(i, grid_size(1))~=0 
        adj(i, i+1) = 1;
    end
    if mod(i, grid_size(1))~=1
        adj(i, i-1) = 1;
    end
    if i<=grid_size(1)*(grid_size(2)-1)
        adj(i, i+grid_size(1)) = 1;
    end
    if i>grid_size(1)
        adj(i, i-grid_size(1)) = 1;
    end
end

fm1 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f8,')');
fm2 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f9,')');

% Adjacency matrix
A = adj;

% Initial positions
n = size(A,1);
W0 = zeros(n,3);
M0 = zeros(n,3);
W0(:,1) = [zeros(6,1);1;zeros(n-7,1)];
W0(:,2) = [1;zeros(n-1,1)];
W0(:,3) = [0;1;zeros(n-2,1)];
M0(:,1) = [0;0;1;zeros(n-3,1)];
M0(:,2) = [0;0;0;1;zeros(n-4,1)];
M0(:,3) = [0;0;0;0;1;zeros(n-5,1)];

NW = sum(sum(W0));
NM = sum(sum(M0));
N = NW + NM;

% Collision avoidence flag,
CA_flag = 1;
t_deliver = 7;
t_spec1 = 1;
t_spec2 = 2;

[W, Wtotal, Z, mytimes, sol] = main_template_region1(fm1,A,h,W0,Obs,CA_flag,M0,fm2,t_deliver,t_spec1,t_spec2);

W1T = W;

time = clock;

save('dataW.mat','W','W','Wtotal','Wtotal','ZLoop','ZLoop','A','A','mygrid','mygrid', 'Z', 'Z','sol','sol');
grid_plot36('dataW.mat');

%% Region 2
W = [];
Z = [];
Wtotal = [];
f1 = [];
f2 = [];
f3 = [];
f4 = [];
f5 = [];
f6 = [];
f7 = [];
mygrid = [];
state_labels = [];
adj = [];
A = [];

% define a gridworld
grid_size = [6, 6];
mygrid = ones(grid_size);

% Room 1&2
mygrid(1:5, 5:6) = 0.8;
mygrid(1:5, 2:3) = 0.6;
mygrid(5, 4) = 0.6;

% narrow passage
mygrid(3, 3:4) = 0.4;

% Obstacles
mygrid(1:2, 4) = 0;
mygrid(4, 4) = 0;

% charging station
mygrid(5,2) = 0.2;
mygrid(1,6) = 0.2;

% Deliver spot
mygrid(6,4) = 0.3;
mygrid(3,1) = 0.3;

state_labels = mygrid(:);

CS = find(state_labels(:)==0.2)';
cs = num2str(CS);
DS = find(state_labels(:)==0.3)';
ds = num2str(DS);
Pass = find(state_labels(:)==0.4)';
pass = num2str(Pass);
Room1 = find(state_labels(:)==0.8)';
room1 = num2str(Room1);
Room2 = find(state_labels(:)==0.6)';
room2 = num2str(Room2);
Room3 = find(state_labels(:)==1)';
room3 = num2str(Room3);

% visualization
figure
vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
imshow(kron(vis,ones(25,25)))
% pass_ends = [23,73,Pass];

% spec is the conjunction of the following
Obs = state_labels(:)==0;                   %avoid obstacles

% At most one robot on pass
f1 = strcat('GG(Neg(TP([',pass,'],[2])))');                               
f2 = strcat('GG(TP([',num2str(setdiff(1:36,Pass)),'],[2]))');             

% Populate Room1 and Room2 by at least 2 robots
f3 = strcat('GF(TP([',num2str(Room1),'],[2]))');       
f4 = strcat('GF(TP([',num2str(Room2),'],[2]))');        

% At most 1 robot at the lower zone.   
f5 = strcat('GG(Neg(TP([',num2str(Room3),'],[1])))');    
f6 = strcat('GG(TP([',num2str(setdiff(1:36,Room3)),'],[3]))'); 

% All robots should visit the charging station.
f7 = strcat('TP(GFI([',num2str(CS), ']),[3])');

% Another surveilence task!
f8 = strcat('FG(TP([',num2str(Room1),'],[2]))');       
f9 = strcat('FG(TP([',num2str(Room2),'],[2]))');        

adj = eye(numel(mygrid)); %allow self-transition

for i=1:length(state_labels)
    if mod(i, grid_size(1))~=0 
        adj(i, i+1) = 1;
    end
    if mod(i, grid_size(1))~=1
        adj(i, i-1) = 1;
    end
    if i<=grid_size(1)*(grid_size(2)-1)
        adj(i, i+grid_size(1)) = 1;
    end
    if i>grid_size(1)
        adj(i, i-grid_size(1)) = 1;
    end
end

fm1 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f8,')');
fm2 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f9,')');

% Adjacency matrix
A = adj;

% Initial positions
n = size(A,1);
W0 = zeros(n,3);
M0 = zeros(n,3);

W0(:,1) = [zeros(24,1);1;zeros(n-25,1)];
W0(:,2) = [zeros(30,1);1;zeros(n-31,1)];
W0(:,3) = [zeros(31,1);1;zeros(n-32,1)];
M0(:,1) = [zeros(32,1);1;zeros(n-33,1)];
M0(:,2) = [zeros(33,1);1;zeros(n-34,1)];
M0(:,3) = [zeros(34,1);1;zeros(n-35,1)];

NW = sum(sum(W0));
NM = sum(sum(M0));
N = NW + NM;

% Collision avoidence flag,
CA_flag = 1;
t_deliver = 7;
t_spec1 = 1;
t_spec2 = 2;

[W, Wtotal, Z, mytimes, sol] = main_template_region2(fm1,A,h,W0,Obs,CA_flag,M0,fm2,t_deliver,t_spec1,t_spec2);

W2T = W;

time = clock;

save('dataW.mat','W','W','Wtotal','Wtotal','ZLoop','ZLoop','A','A','mygrid','mygrid', 'Z', 'Z','sol','sol');
grid_plot36('dataW.mat');


%% Region 3
W = [];
Z = [];
Wtotal = [];
f1 = [];
f2 = [];
f3 = [];
f4 = [];
f5 = [];
f6 = [];
f7 = [];
mygrid = [];
state_labels = [];
adj = [];
A = [];

% define a gridworld
grid_size = [6, 6];
mygrid = ones(grid_size);

% Room 1&2
mygrid(2:6, 1:2) = 0.8;
mygrid(2:6, 4:5) = 0.6;
mygrid(2, 3) = 0.6;

% narrow passage
mygrid(4, 3:4) = 0.4;

% Obstacles
mygrid(5:6, 3) = 0;
mygrid(3, 3) = 0;

% charging station
mygrid(2,5) = 0.2;
mygrid(6,1) = 0.2;


% Deliver spot
mygrid(4,6) = 0.3;
mygrid(1,3) = 0.3;

state_labels = mygrid(:);

CS = find(state_labels(:)==0.2)';
cs = num2str(CS);
DS = find(state_labels(:)==0.3)';
ds = num2str(DS);
Pass = find(state_labels(:)==0.4)';
pass = num2str(Pass);
Room1 = find(state_labels(:)==0.8)';
room1 = num2str(Room1);
Room2 = find(state_labels(:)==0.6)';
room2 = num2str(Room2);
Room3 = find(state_labels(:)==1)';
room3 = num2str(Room3);

% visualization
figure
vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
imshow(kron(vis,ones(25,25)))
% pass_ends = [23,73,Pass];

% spec is the conjunction of the following
Obs = state_labels(:)==0;                   %avoid obstacles

% At most one robot on pass
f1 = strcat('GG(Neg(TP([',pass,'],[2])))');                               
f2 = strcat('GG(TP([',num2str(setdiff(1:36,Pass)),'],[2]))');             

% Populate Room1 and Room2 by at least 2 robots
f3 = strcat('GF(TP([',num2str(Room1),'],[2]))');       
f4 = strcat('GF(TP([',num2str(Room2),'],[2]))');        

% At most 1 robot at the lower zone.   
f5 = strcat('GG(Neg(TP([',num2str(Room3),'],[1])))');     
f6 = strcat('GG(TP([',num2str(setdiff(1:36,Room3)),'],[3]))'); 

% All robots should visit the charging station.
f7 = strcat('TP(GFI([',num2str(CS), ']),[3])');

% Another surveilence task!
f8 = strcat('FG(TP([',num2str(Room1),'],[2]))');       
f9 = strcat('FG(TP([',num2str(Room2),'],[2]))');        

adj = eye(numel(mygrid)); %allow self-transition

for i=1:length(state_labels)
    if mod(i, grid_size(1))~=0 
        adj(i, i+1) = 1;
    end
    if mod(i, grid_size(1))~=1
        adj(i, i-1) = 1;
    end
    if i<=grid_size(1)*(grid_size(2)-1)
        adj(i, i+grid_size(1)) = 1;
    end
    if i>grid_size(1)
        adj(i, i-grid_size(1)) = 1;
    end
end

fm1 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f8,')');
fm2 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f9,')');

% Adjacency matrix
A = adj;

% Initial positions
n = size(A,1);
W0 = zeros(n,3);
M0 = zeros(n,3);

W0(:,1) = [zeros(11,1);1;zeros(n-12,1)];
W0(:,2) = [zeros(5,1);1;zeros(n-6,1)];
W0(:,3) = [zeros(4,1);1;zeros(n-5,1)];
M0(:,1) = [zeros(3,1);1;zeros(n-4,1)];
M0(:,2) = [zeros(2,1);1;zeros(n-3,1)];
M0(:,3) = [zeros(1,1);1;zeros(n-2,1)];

NW = sum(sum(W0));
NM = sum(sum(M0));
N = NW + NM;

% Collision avoidence flag,
CA_flag = 1;
t_deliver = 7;
t_spec1 = 1;
t_spec2 = 2;

[W, Wtotal, Z, mytimes, sol] = main_template_region3(fm1,A,h,W0,Obs,CA_flag,M0,fm2,t_deliver,t_spec1,t_spec2);

W3T = W;

time = clock;

save('dataW.mat','W','W','Wtotal','Wtotal','ZLoop','ZLoop','A','A','mygrid','mygrid', 'Z', 'Z','sol','sol');
grid_plot36('dataW.mat');


%% Region 4
W = [];
Z = [];
Wtotal = [];
f1 = [];
f2 = [];
f3 = [];
f4 = [];
f5 = [];
f6 = [];
f7 = [];
mygrid = [];
state_labels = [];
adj = [];
A = [];

% define a gridworld
grid_size = [6, 6];
mygrid = ones(grid_size);

% Room 1&2
mygrid(2:6, 5:6) = 0.8;
mygrid(2:6, 2:3) = 0.6;
mygrid(2, 4) = 0.6;

% narrow passage
mygrid(4, 3:4) = 0.4;

% Obstacles
mygrid(5:6, 4) = 0;
mygrid(3, 4) = 0;

% charging station
mygrid(2,2) = 0.2;
mygrid(6,6) = 0.2;

% Deliver spot
mygrid(4,1) = 0.3;
mygrid(1,4) = 0.3;

state_labels = mygrid(:);

CS = find(state_labels(:)==0.2)';
cs = num2str(CS);
DS = find(state_labels(:)==0.3)';
ds = num2str(DS);
Pass = find(state_labels(:)==0.4)';
pass = num2str(Pass);
Room1 = find(state_labels(:)==0.8)';
room1 = num2str(Room1);
Room2 = find(state_labels(:)==0.6)';
room2 = num2str(Room2);
Room3 = find(state_labels(:)==1)';
room3 = num2str(Room3);

% visualization
figure
vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
imshow(kron(vis,ones(25,25)))
% pass_ends = [23,73,Pass];

% spec is the conjunction of the following
Obs = state_labels(:)==0;                   %avoid obstacles

% At most one robot on pass
f1 = strcat('GG(Neg(TP([',pass,'],[2])))');                               
f2 = strcat('GG(TP([',num2str(setdiff(1:36,Pass)),'],[2]))');             

% Populate Room1 and Room2 by at least 2 robots
f3 = strcat('GF(TP([',num2str(Room1),'],[2]))');       
f4 = strcat('GF(TP([',num2str(Room2),'],[2]))');        

% At most 1 robot at the lower zone.   
f5 = strcat('GG(Neg(TP([',num2str(Room3),'],[1])))');     
f6 = strcat('GG(TP([',num2str(setdiff(1:36,Room3)),'],[3]))'); 

% All robots should visit the charging station.
f7 = strcat('TP(GFI([',num2str(CS), ']),[3])');

% Another surveilence task!
f8 = strcat('FG(TP([',num2str(Room1),'],[2]))');       
f9 = strcat('FG(TP([',num2str(Room2),'],[2]))');        

adj = eye(numel(mygrid)); %allow self-transition

for i=1:length(state_labels)
    if mod(i, grid_size(1))~=0 
        adj(i, i+1) = 1;
    end
    if mod(i, grid_size(1))~=1
        adj(i, i-1) = 1;
    end
    if i<=grid_size(1)*(grid_size(2)-1)
        adj(i, i+grid_size(1)) = 1;
    end
    if i>grid_size(1)
        adj(i, i-grid_size(1)) = 1;
    end
end

fm1 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f8,')');
fm2 = strcat('And(',f1,',',f2,',',f5,',',f7,',',f9,')');

% Adjacency matrix
A = adj;

% Initial positions
n = size(A,1);
W0 = zeros(n,3);
M0 = zeros(n,3);

W0(:,1) = [zeros(29,1);1;zeros(n-30,1)];
W0(:,2) = [zeros(35,1);1;zeros(n-36,1)];
W0(:,3) = [zeros(34,1);1;zeros(n-35,1)];
M0(:,1) = [zeros(33,1);1;zeros(n-34,1)];
M0(:,2) = [zeros(32,1);1;zeros(n-33,1)];
M0(:,3) = [zeros(31,1);1;zeros(n-32,1)];

NW = sum(sum(W0));
NM = sum(sum(M0));
N = NW + NM;

% Collision avoidence flag,
CA_flag = 1;
t_deliver = 7;
t_spec1 = 1;
t_spec2 = 2;

[W, Wtotal, Z, mytimes, sol] = main_template_region4(fm1,A,h,W0,Obs,CA_flag,M0,fm2,t_deliver,t_spec1,t_spec2);

W4T = W;

time = clock;

save('dataW.mat','W','W','Wtotal','Wtotal','ZLoop','ZLoop','A','A','mygrid','mygrid', 'Z', 'Z','sol','sol');
grid_plot36('dataW.mat');


%% Region 1 2 3 4
W = [];
Z = [];
Wtotal = [];
f1 = [];
f2 = [];
f3 = [];
f4 = [];
f5 = [];
f6 = [];
f7 = [];
mygrid = [];
state_labels = [];
adj = [];
A = [];

% define a gridworld
grid_size = [11, 11];
mygrid = ones(grid_size);

% Room 1&2
mygrid(1:5, 1:2) = 0.8;
mygrid(7:11, 1:2) = 0.8;
mygrid(1:5, 10:11) = 0.8;
mygrid(7:11, 10:11) = 0.8;

mygrid(1:5, 4:5) = 0.6;
mygrid(7:11, 4:5) = 0.6;
mygrid(1:5, 7:8) = 0.6;
mygrid(7:11, 7:8) = 0.6;

mygrid(5, 3) = 0.6;
mygrid(5, 9) = 0.6;
mygrid(7, 3) = 0.6;
mygrid(7, 9) = 0.6;

% narrow passage
mygrid(3, 3:4) = 0.4;
mygrid(3, 8:9) = 0.4;
mygrid(9, 3:4) = 0.4;
mygrid(9, 8:9) = 0.4;

% Obstacles
mygrid(1:2, 3) = 0;
mygrid(4, 3) = 0;
mygrid(10:11, 3) = 0;
mygrid(8, 3) = 0;
mygrid(1:2, 9) = 0;
mygrid(4, 9) = 0;
mygrid(10:11, 9) = 0;
mygrid(8, 9) = 0;

% charging station
mygrid(1,1) = 0.2;
mygrid(5,5) = 0.2;
mygrid(11,1) = 0.2;
mygrid(5,7) = 0.2;
mygrid(1,11) = 0.2;
mygrid(7,5) = 0.2;
mygrid(11,11) = 0.2;
mygrid(7,7) = 0.2;

% Deliver spot
mygrid(3,6) = 0.3;
mygrid(6,3) = 0.3;
mygrid(9,6) = 0.3;
mygrid(6,9) = 0.3;

state_labels = mygrid(:);

CS = find(state_labels(:)==0.2)';
cs = num2str(CS);
DS = find(state_labels(:)==0.3)';
ds = num2str(DS);
Pass = find(state_labels(:)==0.4)';
pass = num2str(Pass);
Room1 = find(state_labels(:)==0.8)';
room1 = num2str(Room1);
Room2 = find(state_labels(:)==0.6)';
room2 = num2str(Room2);
Room3 = find(state_labels(:)==1)';
room3 = num2str(Room3);

% visualization
figure
vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;
imshow(kron(vis,ones(25,25)))


W = binvar(repmat(121,1,24),repmat(h+1,1,24),'full'); 
for i = 1:24
    W{i} = zeros(121,h+1);
end
for i = 1:6
    W{i}(1:6,:)=W1T{i}(1:6,:);
    W{i}(12:17,:)=W1T{i}(7:12,:);
    W{i}(23:28,:)=W1T{i}(13:18,:);
    W{i}(34:39,:)=W1T{i}(19:24,:);
    W{i}(45:50,:)=W1T{i}(25:30,:);
    W{i}(56:61,:)=W1T{i}(31:36,:);
end
for i = 7:12
    W{i}(56:61,:)=W2T{i-6}(1:6,:);
    W{i}(67:72,:)=W2T{i-6}(7:12,:);
    W{i}(78:83,:)=W2T{i-6}(13:18,:);
    W{i}(89:94,:)=W2T{i-6}(19:24,:);
    W{i}(100:105,:)=W2T{i-6}(25:30,:);
    W{i}(111:116,:)=W2T{i-6}(31:36,:);
end
for i = 13:18
    W{i}(6:11,:)=W3T{i-12}(1:6,:);
    W{i}(17:22,:)=W3T{i-12}(7:12,:);
    W{i}(28:33,:)=W3T{i-12}(13:18,:);
    W{i}(39:44,:)=W3T{i-12}(19:24,:);
    W{i}(50:55,:)=W3T{i-12}(25:30,:);
    W{i}(61:66,:)=W3T{i-12}(31:36,:);
end
for i = 19:24
    W{i}(61:66,:)=W4T{i-18}(1:6,:);
    W{i}(72:77,:)=W4T{i-18}(7:12,:);
    W{i}(83:88,:)=W4T{i-18}(13:18,:);
    W{i}(94:99,:)=W4T{i-18}(19:24,:);
    W{i}(105:110,:)=W4T{i-18}(25:30,:);
    W{i}(116:121,:)=W4T{i-18}(31:36,:);
end

% WF = binvar(repmat(121,1,24),repmat(h+1,1,24),'full'); 
% for agent = 1 : 24
%     for t = 1 : h+1
%         if W{agent}(:,t+1) - W{agent}(:,t) == zeros(121,1)
%             WF{agent}(:,h+1-t+1) = zeros(121,1);
%         else
%             WF{agent}(:,t) = W{agent}(:,t);
%         end
%     end
% end
% 
% W = WF;
        


save('dataW.mat','W','W','ZLoop','ZLoop','mygrid','mygrid');
grid_plot121('dataW.mat');