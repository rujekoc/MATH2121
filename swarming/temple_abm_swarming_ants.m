function temple_abm_swarming_ants
%TEMPLE_ABM_SWARMING_ANTS
%   Model for foraging ants. Each agent (ant) is moving
%   with a fixed speed. It can only adjust its direction
%   (angle) of motion, affected by some pheromone
%   concentration field. Specifically, each agent
%   determines the largest pheromone concentration ahead
%   and pushes its direction angle towards that direction.
%   In turn, every agent leaves a trail of pheromones when
%   walking. There is a nest and a food source. Agents
%   reaching the food become active, resulting in a
%   more direct motion and more pheronome secretion.
%
% 04/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = 60; % initial number of agents
ns = 1e5; % number of steps
ax = [150 100]; % problem size (integer in each direction)
v = 1; % base speed of agents (distance per step)
mu_D = .1; % diffusion of pheromone field per step
mu_E = .003; % evaporation rate of pheromone field per step
na = 13; % number of angles in look-ahead
phi_a_max = pi/8; % maximum angle of look-ahead
da_rand = .5; % magitude of random angle change
F_nest = @(x,y) x<=ax(1)*.3&y<=ax(2)*.3; % position of nest
F_food = @(x,y) x>=ax(1)*.7&y>=ax(2)*.7; % position of food

% Initialization
X = zeros(0,2); % initialize position array
while size(X,1)<n % iterate until enough agents are placed in nest
    xa = ax(1)*rand(n,1); ya = ax(2)*rand(n,1); % random positions
    ind_nest = F_nest(xa,ya); % indices of positions inside nest
    X = [X;xa(ind_nest),ya(ind_nest)]; % concatenate position array
end
X = X(1:n,:); % truncate position array to have exactly n agents
D = rand(n,1)*2*pi; % initial direction angles of agents
A = false(n,1); % marker whether ant is carrying food
px = 0:ax(1); py = 0:ax(2); % vectors for concentration field
[PX,PY] = meshgrid(px,py); % generate 2d position matrices
F = PX*0; % pheromone concentration field
phi_a = linspace(-1,1,na)*phi_a_max; % angles in look-ahead
ea = ones(1,na); % vector of ones of look-ahead angles

% Computation
for j = 1:ns % loop over steps
    % Update positions and directions
    X(:,1) = X(:,1)+v*cos(D); % update
    X(:,2) = X(:,2)+v*sin(D); % position
    % Let agents bounce of walls
    ind = (X(:,1)<0&cos(D)<0)|... % who is hitting a wall
        (X(:,1)>ax(1)&cos(D)>0); % horizontally
    D(ind) = pi-D(ind); % reverse x-direction
    ind = (X(:,2)<0&sin(D)<0)|... % who is hitting a wall
        (X(:,2)>ax(2)&sin(D)>0); % vertically
    D(ind) = -D(ind); % reverse y-direction
    % Move agents that are outside of domain into the domain
    X(:,1) = min(max(X(:,1),0+1e-9),ax(1)-1e-9);
    X(:,2) = min(max(X(:,2),0+1e-9),ax(2)-1e-9);
    
    % Look ahead for largest existing pheromone concentration
    Phi = D*ea+ones(n,1)*phi_a; % matrix of look-ahead angles
    Xa = X(:,1)*ea+(2*v)*cos(Phi); % positions of
    Ya = X(:,2)*ea+(2*v)*sin(Phi); % look-ahead points
    Fa = interp2(px,py,F,Xa,Ya)'; % concentration at look-ahead points
    Fa(isnan(Fa)) = 0; % set values outside domain to 0
    [maxv,mi] = max(Fa); % values and angle indices of max concentration
    lambda = min(maxv,1); % magnitude of largest concentration jump
    D = D+(lambda.*phi_a(mi)+... % push angle towards highest value
        (1-lambda).*(2*rand(1,n)-1)*... % or random direction,
        phi_a_max*da_rand)'.*(1-A/2)*.5; % less strong for active agents
    
    % Update pheromone concentration field
    for i = 1:n % loop over agents to have them add to field
        L = max(2*v-sqrt((PX-X(i,1)).^2+... % local influence
            (PY-X(i,2)).^2),0)/(2*v)*... % of this agent (radius = 2*v)
            (1+A(i))*.05; % active agents produce more pheromones
        F = F+L; % add to existing pheromone concentration field
    end
    F = (1-mu_D)*F+mu_D*(F([2:end end],:)+... % diffusion of pheromone
        F([1 1:end-1],:)+F(:,[2:end end])+F(:,[1 1:end-1]))/4; % field
    F = (1-mu_E)*F; % evaporation of pheromone field
    F = min(F,1); % pheromone concentration can at most be 1
    
    % Check if agents reached food or reached nest
    ind_home = A&F_nest(X(:,1),X(:,2)); % agents who came back to nest
    A(ind_home) = false; % agents coming back to nest become inactive
    D(ind_home) = D(ind_home)+pi; % and revert their direction
    ind_heureka = ~A&F_food(X(:,1),X(:,2)); % agents who just found food
    A(ind_heureka) = true; % activate those agents
    D(ind_heureka) = D(ind_heureka)+pi; % and revert their direction
    
    % Plotting
    clf
    imagesc(px,py,F) % plot concentration field
    colormap(jet), caxis([0,1])
    hold on
    plot([1;1;1]*X(~A,1)'+1*[-cos(D(~A')-.3)';cos(D(~A'))';-cos(D(~A')+.3)'],...
        [1;1;1]*X(~A,2)'+1*[-sin(D(~A')-.3)';sin(D(~A'))';-sin(D(~A')+.3)'],...
        'k-','linewidth',2) % plot inactive agents
    plot([1;1;1]*X(A,1)'+1*[-cos(D(A')-.3)';cos(D(A'))';-cos(D(A')+.3)'],...
        [1;1;1]*X(A,2)'+1*[-sin(D(A')-.3)';sin(D(A'))';-sin(D(A')+.3)'],...
        'w-','linewidth',2) % plot active agents
    hold off
    axis equal xy, axis([0 ax(1) 0 ax(2)])
    xlabel('x'), ylabel('y') % axis labels
    title('Foraging ants')
    drawnow
end
