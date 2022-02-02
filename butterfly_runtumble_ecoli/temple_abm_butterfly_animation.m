function temple_abm_butterfly_animation
%TEMPLE_ABM_BUTTERFLY_ANIMATION
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
%   This code produces an animation of the paths of 10
%   butterflies, doing their walks one after another.
%
% 01/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
N = 10; % number of butterflies
ns = 150; % number of random walk steps
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
rx = [-1;-1;-1;0;0;1;1;1]; % x-coordinate of neighbor cells of origin
ry = [-1;0;1;-1;1;-1;0;1]; % y-coordinate of neighbor cells of origin

% Plot background image (elevation)
clf
imagesc(px,py,F) % plot elevation as color map
axis equal xy, axis(ax)
xlabel('x'), ylabel('y') % axis labels
hold on
plot(x0(1),x0(2),'ro') % starting position

for i = 1:N % loop over number of butterflies
    title(sprintf('Random walk over elevation map (butterfly %d/%d)',i,N))
    X = x0; % set initial position
    for j = 1:ns % loop over steps
        % Random walk step
        if rand<q % with probability q
            nf = f(X(end,1)+rx,X(end,2)+ry); % elev. of neighboring cells
            [~,ind] = max(nf); % index of entry with highest elevation
        else % otherwise, with probability 1-q
            ind = randi(8); % choose random index for neighbor cell
        end
        step = [rx(ind),ry(ind)]; % step to neighbor cell
        X(end+1,:) = X(end,:)+step; % take step and append matrix
        % Plot random walk path (just computed segment)
        plot(X(end-1:end,1),X(end-1:end,2),'k.-')
        drawnow
    end
end
hold off
