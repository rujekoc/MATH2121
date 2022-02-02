function temple_abm_butterfly_corridor_width
%TEMPLE_ABM_BUTTERFLY_CORRIDOR_WIDTH
%   Random walk in 2d over a background map. This example
%   models the motion of butterflies. In each step, the
%   butterfly executes one of two possible actions: with
%   probability q, it move to the adjacent cell with the
%   highest elevation; otherwise (with probability 1-q),
%   it moves to a randomly selected adjacent cell.
%   This example is taken from the book
%   [Railsback, Grimm, Agent-based and Individual-based
%   Modeling: A Practical Introduction, Princeton Univ.
%   Press, 2011].
%   This code computes the paths of 50 butterflies and
%   outputs the total number of patches visited (by any
%   butterfly) and the mean path length. The corridor
%   width is then the ratio of those two values.
%   [note: whether this is a good "definition" of
%   corridor width is debatable.]
%
% 02/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
N = 50; % number of butterflies
q = .4; % probability to move to neighbor cell with highest elevation
f = @(x,y) max(100-sqrt((x-30).^2+(y-30).^2),... % elevation function,
    50-sqrt((x-120).^2+(y-100).^2)); % consisting of two conical humps
ax = [0 150 0 150]; % domain for plotting
x0 = [85,95]; % initial position of butterfly

% Initialization
px = ax(1):ax(2); % x-vector for plotting of elevation
py = ax(3):ax(4); % y-vector for plotting of elevation
[PX,PY] = meshgrid(px,py); % generate 2d data for plotting
F = f(PX,PY); % elevation data
V = false(size(PX)); % 2d array which cells have been visited
xf = zeros(N,2); % array for final positions of butterflies
rx = [-1;-1;-1;0;0;1;1;1]; % x-coordinate of neighbor cells of origin
ry = [-1;0;1;-1;1;-1;0;1]; % y-coordinate of neighbor cells of origin

% Simulation of random walks
for i = 1:N % loop over number of butterflies
    x = x0; % set initial position
    while 1 % loop over steps
        % Nearby elevation and stopping criterion
        nf = f(x(1)+rx,x(2)+ry); % elevation of neighboring cells
        [val,ind] = max(nf); % value and index with highest elevation
        if val<f(x(1),x(2)) % if current cell is higher than all
            break % neighboring cell (hill top), stop random walk
        end
        if rand<1-q % with probability 1-q,
            ind = randi(8); % choose random index for neighbor cell
        end % (otherwise, the highest elevation had been chosen before)
        x = x+[rx(ind),ry(ind)]; % take step to neighbor cell
        V(ax(1)+1+x(2),ax(3)+1+x(1)) = true; % activate current cell
    end
    xf(i,:) = x; % store final position
end

% Compute quantities of interest
nr_visited_cells = nnz(V); % number of cells visited by any butterfly
dist = sqrt(sum((xf-ones(N,1)*x0).^2,2)); % vector of all distances
avg_dist = mean(dist); % average distances traveled
corridor_width = nr_visited_cells/avg_dist; % width of corridor

% Plotting
F(V) = nan; % set visited patches in elevation map to nan
clf
imagesc(px,py,F) % plot elevation as color map (with visited patches)
hold on
plot(x0(1),x0(2),'ro') % starting position
plot(xf(:,1),xf(:,2),'m*') % final positions
hold off
axis equal xy, axis(ax)
xlabel('x'), ylabel('y') % axis labels
title(sprintf(['Butterfly model: cells visited=%d; avg. dist=%0.2f; ',...
    'corridor width=%0.2f'],nr_visited_cells,avg_dist,corridor_width))
