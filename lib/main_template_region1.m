function [W, Wtotal, Z, mytimes, sol] = main_template_region1(fm1,A,h,W0,Obs,CA_flag,M0,fm2,t_deliver,t_spec1,t_spec2)

time = clock;             
disp([ 'Started at ', ...
num2str(time(4)), ':',... % Returns year as character  
num2str(time(5)), ' on ',... % Returns month as character   
num2str(time(3)), '/',... % Returns day as char
num2str(time(2)), '/',... % returns hour as char..
num2str(time(1))]);

if h==0
    disp('Trajectory must be greater than 0');    
    assert(h>0);            
end

tos = tic;                 

global W Wtotal Z zLoop ZLoop bigM epsilon tau NW NM bigM2 W1 W2 BIGM Z1 Z2;

% Number of agents
N = sum(sum(W0)) + sum(sum(M0));                
% bigM notation
% bigM notation
bigM = sum(sum(W0))+1;
bigM2 = sum(sum(M0))+1;
BIGM = N + 1;

NW = sum(sum(W0));
NM = sum(sum(M0));

% number of states
I = length(A);              

% Control input
% W = binvar(repmat(I,1,N),repmat(h+1,1,N),'full');    
W1 = binvar(repmat(I,1,NW),repmat(h+1,1,NW),'full'); 
W2 = binvar(repmat(I,1,NM),repmat(h+1,1,NM),'full'); 
W = [W1 W2];


if N == 1
     W = {W};
end


% Initial state constraint
%disp('Creating other constraints...')
fInit = getInit7(W0,M0);                     

% Obstacle Avoidence Constraint
fObs = getObs7(Obs);                    

% System dynamics constraint
fDyn = getDyn7(A,CA_flag);                

% Loop constraint
fLoop= getLoop7();

% Collision Avoidence Constraint         
fCol = getCol7();

% Timing of other constraints
toe = toc(tos);                        
disp(['    Done with other constraints (',num2str(toe),') seconds'])

% LTL constraint
%disp('Creating LTL constraints...')
tltls=tic;
Z = {};
Z1 = {};
Z2 = {};

[fLTL1,phi1] = getLTL7(fm1,1);
[fLTL2,phi2] = getLTL8(fm2,1);

Z = [Z1 Z2];




%%
v_send = [];
v_pick = [];
v_pick = [zeros(1,17),1,zeros(1,14),0,zeros(1,3)];
v_send = [zeros(1,17),0,zeros(1,14),1,zeros(1,3)];
v_s_1 = 0;
v_p_1 = 0;
v_s_2 = 0;
v_p_2 = 0;
v_a_1 = 0;
v_a_2 = 0;

for i = 1 : t_deliver
    v_s_1 = v_s_1 + v_send * W{1}(:,i)
    v_s_1 = v_s_1 + v_send * W{2}(:,i)
    v_s_1 = v_s_1 + v_send * W{3}(:,i)
end

for i = 1 : t_deliver
    v_p_1 = v_p_1 + v_pick * W{4}(:,i);
    v_p_1 = v_p_1 + v_pick * W{5}(:,i);
    v_p_1 = v_p_1 + v_pick * W{6}(:,i);
end

for i = t_deliver+1 : h
    v_s_2 = v_s_2 + v_send * W{1}(:,i);
    v_s_2 = v_s_2 + v_send * W{2}(:,i);
    v_s_2 = v_s_2 + v_send * W{3}(:,i);
end

for i = t_deliver+1 : h
    v_p_2 = v_p_2 + v_pick * W{4}(:,i);
    v_p_2 = v_p_2 + v_pick * W{5}(:,i);
    v_p_2 = v_p_2 + v_pick * W{6}(:,i);
end

for i = 1 : h
    v_a_1 = v_a_1 + v_pick * W{1}(:,i);
    v_a_1 = v_a_1 + v_pick * W{2}(:,i);
    v_a_1 = v_a_1 + v_pick * W{3}(:,i);
end

for i = 1 : h
    v_a_2 = v_a_2 + v_send * W{4}(:,i);
    v_a_2 = v_a_2 + v_send * W{5}(:,i);
    v_a_2 = v_a_2 + v_send * W{6}(:,i);
end

fPenalty = 0;
fPC = 0;
for agent = 1 : N
    for space = t_deliver+1 : h-1
        WE = W{agent}(:,space+1)-W{agent}(:,space);
        fPenalty = fPenalty + (WE'*WE)*(space);
    end
end



%%
% fBound = 0;
% fB1 = 0;
% fB2 = 0;
% fB3 = 0;
% WB1 = [zeros(1,17),100,zeros(1,14),100,zeros(1,3)];
% WB2 = [zeros(1,17),-400,zeros(1,14),0,zeros(1,3)];
% WB3 = [zeros(1,17),0,zeros(1,14),-400,zeros(1,3)];
% for t = 1 : t_deliver - 1
%     fBound = fBound + WB1*W{1}(:,t);
%     fBound = fBound + WB1*W{2}(:,t);
%     fBound = fBound + WB1*W{3}(:,t);
%     fBound = fBound + WB1*W{4}(:,t);
%     fBound = fBound + WB1*W{5}(:,t);
%     fBound = fBound + WB1*W{6}(:,t);
% end
% Random1 = randi([1,3],1,1);
% Random2 = randi([4,6],1,1);
% 
% for i = 1:6
%     fB1 = fB1 + WB1*W{i}(:,t_deliver-1);
%     fB1 = fB1 + WB1*W{i}(:,t_deliver+1);
% end
% 
% if t_spec1 == 1
%     fBound = fBound + WB2*W{Random1}(:,t_deliver);
%     fB2 = fB2 + WB2*W{Random1}(:,t_deliver);
% else
%     fBound = fBound + WB3*W{Random1}(:,t_deliver);
%     fB2 = fB2 + WB3*W{Random1}(:,t_deliver);
% end
% if t_spec2 == 2
%     fBound = fBound + WB3*W{Random2}(:,t_deliver);
%     fB3 = fB3 + WB3*W{Random2}(:,t_deliver);
% else
%     fBound = fBound + WB2*W{Random2}(:,t_deliver);
%     fB3 = fB3 + WB2*W{Random2}(:,t_deliver);
% end
% for t = t_deliver + 1 : h
%     fBound = fBound + WB1*W{1}(:,t);
%     fBound = fBound + WB1*W{2}(:,t);
%     fBound = fBound + WB1*W{3}(:,t);
%     fBound = fBound + WB1*W{4}(:,t);
%     fBound = fBound + WB1*W{5}(:,t);
%     fBound = fBound + WB1*W{6}(:,t);
% end


        
%%

tltle=toc(tltls);
disp(['    Done with LTL constraints (',num2str(tltle),') seconds'])    


% All Constraints
%F = [fInit, fDyn, fLoop, fObs, fLTL, phi==1];
% F = [fInit, fObs, fDyn, fLoop, fLTL1, phi1==1, fLTL2, phi2==1, fB1==0, fB2==-400, fB3==-400];       
F = [fInit, fObs, fDyn, fLoop, fLTL1, phi1==1, fLTL2, phi2==1, v_s_1==1, v_p_1==1, v_s_2==0, v_p_2==0, v_a_1==0, v_a_2==0];

% if CA_flag
%     F = [F fCol];
% end
disp(['    Total number of optimization variables : ', num2str(length(depends(F)))]);

% Solve the optimization problem                   
%H = -epsilon; % maximize epsilon
options = sdpsettings('verbose',8,'solver','gurobi');    
options.gurobi.Heuristics = 0.05;
% Time spent in feasibility heuristics
% 	Type: 	double
% 	Default value: 	0.05
% 	Minimum value: 	0
% 	Maximum value: 	1
% Determines the amount of time spent in MIP heuristics. You can think of the value as the desired fraction of total MIP
% runtime devoted to heuristics (so by default, we aim to spend 5% of runtime on heuristics). Larger values produce more and
% better feasible solutions, at a cost of slower progress in the best bound.
% Note: Only affects mixed integer programming (MIP) models 

options.gurobi.MIPFocus = 2;
% By default, the Gurobi MIP solver strikes a balance between finding new feasible solutions and proving that the current
% solution is optimal. If you are more interested in finding feasible solutions quickly, you can select MIPFocus=1. If you
% believe the solver is having no trouble finding good quality solutions, and wish to focus more attention on proving
% optimality, select MIPFocus=2. 

options.gurobi.timelimit = 2000;
options.gurobi.MIPgap = 0.2;

disp('Solving MILP...')
tms=tic;
% sol = optimize(F,fPenalty,options);
sol = optimize(F,fPenalty,options);
tme=toc(tms);
disp(['    Solved (',num2str(sol.solvertime),') seconds'])

% Assign values
    for n = 1:N
       W{n} = value(W{n}); 
    end
    for i=1:length(Z)
        Z{i}{1} = value(Z{i}{1});
        if ~isnan(Z{i}{1}) 
            1;
        else
            disp(['#### Careful!! {',num2str(i), '} ', num2str(Z{i}{2}), ' is NaN']); 
        end
    end
    Wtotal = value(Wtotal);
    % Loop
    zLoop = value(zLoop);
    ZLoop = value(ZLoop);
    LoopBegins = find(zLoop(:)==1);
    
    
%% 
% if sol.problem == 0                              
%     % Extract and display value
%     disp('## Feasible solution exists ##')
%     % Now get the values
% 
%     for n = 1:N
%        W{n} = value(W{n}); 
%     end
%     for i=1:length(Z)
%         Z{i}{1} = value(Z{i}{1});
%         if ~isnan(Z{i}{1}) 
%             1;
%         else
%             disp(['#### Careful!! {',num2str(i), '} ', num2str(Z{i}{2}), ' is NaN']); 
%         end
%     end
%     Wtotal = value(Wtotal);
%     % Loop
%     zLoop = value(zLoop);
%     ZLoop = value(ZLoop);
%     LoopBegins = find(zLoop(:)==1);
% else
%      W=0;W=0;WT=0;ZLoop=0;zLoop=0;LoopBegins=0;    
%      sol.info
%      yalmiperror(sol.problem)
%      assert(0,'## No feasible solutions found! ##');
% end

ttotal = toc(tos);
mytimes = [ttotal,toe, tltle, sol.solvertime];
yalmip('clear')
