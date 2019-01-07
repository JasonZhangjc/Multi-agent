a = intvar(1,1,'full');
F = [a>=10];       

disp(['    Total number of optimization variables : ', num2str(length(depends(F)))]);

options = sdpsettings('verbose',8,'solver','gurobi');    
options.gurobi.Heuristics = 0.8;

options.gurobi.MIPFocus = 1;

disp('Solving MILP...')
tms=tic;
sol = optimize(F,a,options);
tme=toc(tms);
disp(['    Solved (',num2str(sol.solvertime),') seconds'])


