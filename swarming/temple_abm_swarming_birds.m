function temple_abm_swarming_birds
%TEMPLE_ABM_SWARMING_BIRDS
%   Model for swarming birds. Each agent (bird) is moving
%   with a fixed speed. It can only adjust its direction
%   (angle) of flight, relative to other agents that are
%   nearby. There is a zone of repulsion (radius 0.3),
%   inside which other agents produce a repelling effect.
%   There is also a zone of alignment (radius between 1/3
%   and 1), inside which the direction of other agents
%   is desirable. The angle changes induced by all nearby
%   other agents are averaged and result in a small change
%   of direction for the agent at hand.
%
% 04/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = 200; % initial number of agents
ns = 10000; % number of steps
ax = [0 15 0 15]; % problem domain (integer size in each direction)
v = .03; % speed of agents (distance per step)
a = 0; % magnitude of random angle change per step for agents
mu = .06; % how much direction is adjusted to that of nearby agents

% Initialization
ncx = ax(2)-ax(1); % number of cells in horizontal direction
ncy = ax(4)-ax(3); % number of cells in vertical direction
nc = ncx*ncy; % number of cells
cx = ax(1):ax(2); cy = ax(3):ax(4); % cell boundaries
X = [ax(1)+(ax(2)-ax(1))*(.25+.5*rand(n,1)),... % initial positions of
    ax(3)+(ax(4)-ax(3))*(.25+.5*rand(n,1))]; % agents
D = rand(n,1)*2*pi; % initial angles of agents

% Computation
for j = 1:ns % loop over steps
    % Update positions and directions
    X(:,1) = X(:,1)+v*cos(D); % update
    X(:,2) = X(:,2)+v*sin(D); % position
    D = D+a*randn(size(D)); % change direction of motion
    % Let agents bounce of walls
    ind = (X(:,1)<ax(1)&cos(D)<0)|... % who is hitting a wall
        (X(:,1)>ax(2)&cos(D)>0); % horizontally
    D(ind) = pi-D(ind); % reverse x-direction
    ind = (X(:,2)<ax(3)&sin(D)<0)|... % who is hitting a wall
        (X(:,2)>ax(4)&sin(D)>0); % vertically
    D(ind) = -D(ind); % reverse y-direction
    % Move agents that are outside of domain into the domain
    X(:,1) = min(max(X(:,1),ax(1)+1e-9),ax(2)-1e-9);
    X(:,2) = min(max(X(:,2),ax(3)+1e-9),ax(4)-1e-9);
    
    % Determine list of agents in each cell
    cell_of_agent = floor(X)*[1;ncx]+1; % index of cell of each agent
    agents_in_cell = cell(nc,1); % initialize agents per cell data
    for i = 1:n % loop over all agents
        agents_in_cell{cell_of_agent(i)}(end+1) = i;
    end
    % Determine list of agents in cell and adjacent cells
    i_L = (1:nc)-1+(mod(1:nc,ncx)==1); % cell index shifted left
    i_R = (1:nc)+1-(mod(1:nc,ncx)==0); % cell index shifted right
    i_LD = max(i_L-ncx,1); % cell index shifted left and down
    i_D = max((1:nc)-ncx,1); % cell index shifted down
    i_RD = max(i_R-ncx,1); % cell index shifted right and down
    i_LU = min(i_L+ncx,ncx*(ncy-1)); % cell index shifted left and up
    i_U = min((1:nc)+ncx,ncx*(ncy-1)); % cell index shifted up
    i_RU = min(i_R+ncx,ncx*(ncy-1)); % cell index shifted right and up
    agents_in_and_near_cell = cellfun(@(x1,x2,x3,x4,x5,x6,x7,x8,x9)...
        unique([x1,x2,x3,x4,x5,x6,x7,x8,x9]),...
        agents_in_cell(i_LD),agents_in_cell(i_D),agents_in_cell(i_RD),...
        agents_in_cell(i_L),agents_in_cell(1:nc),agents_in_cell(i_R),...
        agents_in_cell(i_LU),agents_in_cell(i_U),agents_in_cell(i_RU),...
        'un',0);
    
    % Align direction of flight to nearby agents
    D_neighbors = D*0; % initialize average direction of neighbors
    for i = 1:n % loop over all agents
        neighbors = agents_in_and_near_cell{cell_of_agent(i)};
        neighbors = setdiff(neighbors,i); % remove agent itself
        nn = length(neighbors); % number of neighbors
        pos0 = X(neighbors,:)-... % position of neighbors
            ones(nn,1)*X(i,:); % relative to agent
        dist0 = sqrt(sum(pos0.^2,2)); % distance of neighbors to agent
        ind_nearby = dist0<=1; % neighbors within radius 1
        neighbors = neighbors(ind_nearby); % keep only nearby neighbors
        pos0 = pos0(ind_nearby,:); dist0 = dist0(ind_nearby);
        if ~isempty(neighbors) % if there is at least one nearby agent
            ind_too_close = dist0<1/3; % neighbors that are too close
            angle_neighbors = D(neighbors); % align with okay neighbors
            angle_neighbors(ind_too_close) = ... % turn away from
                atan2(-pos0(ind_too_close,2),... % neighbors that are
                -pos0(ind_too_close,1)); % too close
            angle_rel = mod(angle_neighbors-D(i)+pi,... % relative
                2*pi)-pi; % direction angle between neighbors and agent
            avg_angle_rel = sum((1-dist0).*angle_rel)... % weighted
                /sum(1-dist0); % average, counting closer agents more
            D_neighbors(i) = D(i)+avg_angle_rel;
        else % if there are no other agents nearby
            D_neighbors(i) = D(i);
        end
    end
    D = (1-mu)*D+mu*D_neighbors; % bring direction closer to neighbors
    
    % Plotting
    clf
    plot([1;1]*cx,ax([3,4])'*(cx*0+1),'k-',... % draw boundaries
        ax([1,2])'*(cy*0+1),[1;1]*cy,'k-') % of cells
    hold on
    plot([1;1;1]*X(:,1)'+.1*[-cos(D-.3)';cos(D)';-cos(D+.3)'],...
        [1;1;1]*X(:,2)'+.1*[-sin(D-.3)';sin(D)';-sin(D+.3)'],...
        'b-','linewidth',2)
    hold off
    axis equal xy, axis(ax)
    xlabel('x'), ylabel('y') % axis labels
    title('Swarming birds')
    drawnow
end
