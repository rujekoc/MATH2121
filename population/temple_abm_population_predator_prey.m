function temple_abm_population_predator_prey
%TEMPLE_ABM_POPULATION_PREDATOR_PREY
%   Agents (representing two different animal species)
%   move in a 2d box. Agents move with a fixed speed
%   in their direction, and slightly change their
%   direction in each step. An agent can reproduce and
%   die. The probabilities of doing one or the other
%   depend on the population balance in the cell that
%   the agent occupies. For prey, the reproduction
%   rate decreases with the local density of prey, and
%   the death rate increases with the local density of
%   predators. For predators, the reproduction rate
%   increases with the local density of prey, and the
%   death rate increases with the local density of
%   predators.
%
% 02/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
N = [400 100]; % initial number of prey and predators
ns = 10000; % number of steps
ax = [0 10 0 10]; % problem domain
v = [.01,.01]; % speeds of prey and predators (distance per step)
a = [.2;.1]; % magnitude of angle change per step for prey and predators

% Initialization
ncx = (ax(2)-ax(1)); % number of cells in horizontal direction
ncy = (ax(4)-ax(3)); % number of cells in vertical direction
cx = ax(1):ax(2); cy = ax(3):ax(4); % cell boundaries
X{1} = [ax(1)+(ax(2)-ax(1))*rand(N(1),1),... % initial positions of
    ax(3)+(ax(4)-ax(3))*rand(N(1),1)]; % prey (bottom left corner)
X{2} = [ax(1)+(ax(2)-ax(1))*(rand(N(2),1)/2),... % initial positions
    ax(3)+(ax(4)-ax(3))*(rand(N(2),1)/2)]; % of predators (top right)
D{1} = rand(N(1),1)*2*pi; % initial angles of direction of prey
D{2} = rand(N(2),1)*2*pi; % initial angles of direction of predators

for j = 1:ns % loop over steps
    % Update positions and directions
    for k = 1:2 % prey and predators
        X{k}(:,1) = X{k}(:,1)+v(k)*cos(D{k}); % update
        X{k}(:,2) = X{k}(:,2)+v(k)*sin(D{k}); % position
        D{k} = D{k}+a(k)*randn(size(D{k})); % change direction of motion
        % Let agents bounce of walls
        ind = (X{k}(:,1)<ax(1)&cos(D{k})<0)|... % who is hitting a wall
            (X{k}(:,1)>ax(2)&cos(D{k})>0); % horizontally
        D{k}(ind) = pi-D{k}(ind); % reverse x-direction
        ind = (X{k}(:,2)<ax(3)&sin(D{k})<0)|... % who is hitting a wall
            (X{k}(:,2)>ax(4)&sin(D{k})>0); % vertically
        D{k}(ind) = -D{k}(ind); % reverse y-direction
        % Move agents that are outside of domain into the domain
        X{k}(:,1) = min(max(X{k}(:,1),ax(1)+1e-9),ax(2)-1e-9);
        X{k}(:,2) = min(max(X{k}(:,2),ax(3)+1e-9),ax(4)-1e-9);
    end
    
    % Determine population balance in each cell
    cell_of_prey = floor(X{1})*[1;ncx]+1; % index of cell of prey agent
    cell_of_predators = floor(X{2})*[1;ncx]+1; % cell index predator agent
    number_of_prey = zeros(ncx*ncy,1); % initialize count per cell
    number_of_predators = number_of_prey; % initialize count per cell
    % Number of prey in each cell
    [cell_indices,~,agents_in_cell] = unique(cell_of_prey);
    number_of_agents_in_cell = accumarray(agents_in_cell,1);
    number_of_prey(cell_indices) = number_of_agents_in_cell;
    % Number of predators in each cell
    [cell_indices,~,agents_in_cell] = unique(cell_of_predators);
    number_of_agents_in_cell = accumarray(agents_in_cell,1);
    number_of_predators(cell_indices) = number_of_agents_in_cell;

    % Death and reproduction probabilities of each agent
    p_prey_reproduce = .20./(number_of_prey(cell_of_prey)+1);
    p_prey_death = .01+.08*(1-1./(number_of_predators(cell_of_prey)+1));
    p_predator_reproduce = .01+.08*(1-1./(number_of_prey(cell_of_predators)+1));
    p_predator_death = .05*(1-1./(number_of_predators(cell_of_predators)+1));

    % Population dynamics of prey
    ind_reproduce = rand(size(D{1}))<p_prey_reproduce; % reproducing prey
    X_new = X{1}(ind_reproduce,:); % copy the reproducing agents
    D_new = rand(sum(ind_reproduce),1)*2*pi; % random directions
    ind_survive = rand(size(D{1}))>=p_prey_death; % survining agents
    X{1} = [X{1}(ind_survive,:);X_new]; % new prey positions
    D{1} = [D{1}(ind_survive);D_new]; % new prey directions

    % Population dynamics of predators
    ind_reproduce = rand(size(D{2}))<p_predator_reproduce;
    X_new = X{2}(ind_reproduce,:); % copy the reproducing agents
    D_new = rand(sum(ind_reproduce),1)*2*pi; % random directions
    ind_survive = rand(size(D{2}))>=p_predator_death; % survining agents
    X{2} = [X{2}(ind_survive,:);X_new]; % new predator positions
    D{2} = [D{2}(ind_survive);D_new]; % new predator directions
    
    % Plotting
    clf
    plot([1;1]*cx,ax([3,4])'*(cx*0+1),'k-',... % draw boundaries
        ax([1,2])'*(cy*0+1),[1;1]*cy,'k-') % of cells
    hold on
    plot(X{1}(:,1),X{1}(:,2),'.','markersize',12,'color',[0 .8 0])
    plot(X{2}(:,1),X{2}(:,2),'.','markersize',12,'color',[1 0 0])
    hold off
    axis equal xy, axis(ax)
    xlabel('x'), ylabel('y') % axis labels
    title(sprintf('Prey (%d agents) and predators (%d agents)',...
        size(X{1},1),size(X{2},1)))
    drawnow
end
