function grid_plot121(filename)             
load(filename)
% % Loop closes at 10
% 
% % Gives state vector index in loop at 'time'
% time_to_state_pos = @(time) (time<=20)*(time) + (time>20)*(10 + mod(time-10, 11));
% 
% % Gives control index in loop at 'time'-1 (to be used to obtain state at 'time')
% time_to_control_pos = @(time) (time<=19)*(time-1) + (time>19)*(10 + mod(time-11, 11));


k = length(ZLoop);
loopBegins = find(ZLoop(:)==1,1);

% Gives state vector index in loop at 'time'
time_to_state_pos = @(time) (time<=k)*(time) + (time>k)*(loopBegins + mod(time-k-1, k-loopBegins+1));

% Gives control index in loop at 'time'-1 (to be used to obtain state at 'time')
time_to_control_pos = @(time) (time<=k+1)*(time-1) + (time>k+1)*(loopBegins + mod(time-k-2, k-loopBegins+1));


% Return coordinates in a grid world
ind_to_pos_x = @(ind) (1+floor((ind-1)/11));
ind_to_pos_y = @(ind) (1+mod((ind-1),11));


% I = size(A,2);        % num of states
I = 121;
N = length(W);        % num of agents
K = 2*size(W{1},2);   % horizon

traces = zeros(N, K);


% Populate rest of traces
for k=1:K                                         
	t = time_to_state_pos(k);                     
	for agent=1:N                                 
		traces(agent, k) = find(abs(W{agent}(:,t)-1)< 1e-4);
	end
end


clf; 
set(gca, 'LooseInset', get(gca,'TightInset'))

% define a gridworld
figure

vis = zeros(size(mygrid)+2);
vis(2:end-1,2:end-1)=mygrid;

T = 1:40;
cmap = jet(N);   
pos_diff = [[0., 0.]; [0.3,0.3]; [0.3,-0.3]; [-0.3,-0.3]; [-0.3,0.3]];
axis off

ha = tight_subplot(5,8, [0.05 0.01], [0.01 0.04], 0.01);


for i=1:length(T)                             
	axes(ha(i))
	hold on; xlim([0.5, 11.5]); ylim([0.5, 11.5])
	imshow(kron(mygrid,ones(25,25)), 'xdata', [0.5,11.5], 'ydata', [0.5,11.5])
	rectangle('position',[0.5 0.5 11 11],'LineWidth',2);

	for n=1:N                                 
		current_state = traces(n, T(i));
		diff_ = [0 0];%pos_diff(occup(current_state),:);
		xpos = ind_to_pos_x(current_state) + diff_(1);
		ypos = ind_to_pos_y(current_state) + diff_(2);
		%occup(current_state) = occup(current_state) + 1;
		plot(xpos, ypos, 'o', 'color', cmap(n,:), ...
			'markersize', 4, 'MarkerFaceColor', cmap(n,:))

		if current_state ~= traces(n, T(i)+1)
			arrow_dest_x = xpos + (ind_to_pos_x(traces(n, T(i)+1))+ diff_(1) - xpos)*0.75;
			arrow_dest_y = ypos + (ind_to_pos_y(traces(n, T(i)+1))+ diff_(2) - ypos)*0.75;
			arrow([xpos, ypos], [arrow_dest_x, arrow_dest_y], 'length', 2, 'baseangle', 70, 'tipangle', 10, 'color', cmap(n,:));

		end
	end
	title(['$$t=', num2str(T(i)), '$$'],'Interpreter','latex')
end
print -depsc traces.eps

fig = gcf;
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,filename,'-dpdf')
hold on


