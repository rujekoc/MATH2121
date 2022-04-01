function temple_abm_opinion_dynamics_2d
%TEMPLE_ABM_OPINION_DYNAMICS_2D
%   Opinion dynamics with spatial and opinion vicinity.
%   Each agent is affected by other agents who are
%   nearby in a 2d (location,opinion) space.
%   With a low probability, agents can move to a new
%   location.
%
% 04/2018 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

%------------------------------------------------------------------------
% Parameters
%------------------------------------------------------------------------
n = 250; % number of agents
rx = .02; % radii of influence for location
ry = .25; % radii of influence for opinion
ns = 10000; % number of steps
mu = .2; % strength of attraction per step

% Initialization
x = rand(n,1); % initial locations
y = rand(n,1); % initial opinions

% Computation
for i = 0:ns % time loop
    %--------------------------------------------------------------------
    % Plotting
    %--------------------------------------------------------------------
    clf
    for j = 1:n % loop over agents
        patch(x(j)+rx/2*[-1,1,1,-1],y(j)+ry/2*[-1,-1,1,1],[1,.8,.8],'EdgeColor','none')
    end
    hold on
    plot(x,y','.')
    hold off
    axis([0,1,0,1])
    xlabel('location')
    ylabel('opinion')
    title(sprintf('Opinion dynamics with spatial component, step %d',i))
    pause(1e-2)
    
    %--------------------------------------------------------------------
    % Update rule
    %--------------------------------------------------------------------
    a = zeros(n,1); % average opinion
    for j = 1:n % loop over agents
        dx = abs(x-x(j)); % location distance to other agents
        dy = abs(y-y(j)); % opinion distance to other agents
        ind = 0<dx&dx<=rx&0<dy&dy<=ry; % nearby agents
        if any(ind) % if at least one other agent is nearby
            a(j) = mean(y(ind)); % average of other agents' opinion
        else % if no other agents nearby agents
            a(j) = y(j); % use agent's opinion as attractor
        end
    end
    y = y+mu*(a-y); % move opinion towards average opinion
    
    % Possibility (with low probability) of agents to move to new location 
    ind_move = rand(n,1)<1e-3;
    x(ind_move) = rand(sum(ind_move),1);
end
