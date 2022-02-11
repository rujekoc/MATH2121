function temple_abm_population_local(type_of_model)
%TEMPLE_ABM_POPULATION_LOCAL
%   Non-agent-based population dynamics. The population
%   sizes of two species are represented by two numbers
%   that evolve in time. Different population models
%   can be chosen to describe the growth/decay rates of
%   the two populations: (1) predator-prey;
%   (2) non-interactive growth with limited resources;
%   (3) competition; (4) mutalism.
%
% 02/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
if nargin<1, type_of_model = 1; end
ax = [0 2 0 2]; % domain for plotting of vector field
x = .7; % initial prey population
y = .6; % initial predator population
ns = 1000; % number of steps of computation
dt = 1e-2; % time step

% Initialization
switch type_of_model
case 1
    name = 'Lotka–Volterra predator-prey model';
    f = @(x,y) x-x.*y; % growth rate of first species (prey)
    g = @(x,y) x.*y-y; % growth rate of second species (predator)
case 2
    name = 'Logistic growth without interaction';
    f = @(x,y) x-x.^2; % growth rate of first species
    g = @(x,y) y-y.^2; % growth rate of second species
case 3
    name = 'Logistic growth with competition';
    f = @(x,y) x-x.^2-3*x.*y; % growth rate of first species
    g = @(x,y) y-y.^2-2*x.*y; % growth rate of second species
case 4
    name = 'Mutalism';
    f = @(x,y) x-x.^2+.1*x.*y; % growth rate of first species
    g = @(x,y) y-y.^2+.5*x.*y; % growth rate of second species
end
px = linspace(ax(1),ax(2),50); % x-coordinates of plotting
py = linspace(ax(3),ax(4),50); % y-coordinates of plotting
[PX,PY] = meshgrid(px,py);
F = f(PX,PY); G = g(PX,PY); % direction vectors
L = sqrt(F.^2+G.^2); % length of vectors
F = F./L; G = G./L; % normalize vectors

% Plot direction field
clf
quiver(px,py,F,G,.5)
axis equal, axis(ax)
xlabel('x'), ylabel('y') % axis labels
hold on
for j = 0:ns % loop over steps
    if j>0 % in zeroth step do not compute, just plot
        % Update positions and directions
        dx = f(x,y); dy = g(x,y);
        x = x+dt*dx; y = y+dt*dy;
    end
    % Plotting
    plot(x,y,'k.','markersize',12)
    title(sprintf('%s at t=%0.1f',name,dt*j))
    drawnow
end
hold off
