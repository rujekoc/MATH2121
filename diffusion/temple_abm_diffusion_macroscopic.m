function temple_abm_diffusion_macroscopic
%TEMPLE_ABM_DIFFUSION_MACROSCOPIC
%   A macroscopic concentration field is exposed to a
%   2d diffusion equation. The diffusion is approximated
%   via finite volumes: each cell hold a concentration
%   value, and this value changes in time by fluxes
%   through the cell boundaries. Those fluxes, in turn,
%   result from concentration gradients between neighboring
%   cells. The boundary conditions are chosen so that no
%   flux occurs through them (Neumann b.c.).
%
% 02/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
d = 1; % diffusion constant
tf = 1000; % final time
ax = [0 150 0 150]; % problem domain ([xmin xmax ymin ymax])
n = [50 50]; % number of grid cells in each direction
c0 = @(x,y) max(max(150-sqrt((x-30).^2+(y-40).^2),... % initial
    100-sqrt((x-120).^2+(y-100).^2)),0); % concentration field

% Initialization
len = ax([2 4])-ax([1 3]); % size of domain in each direction
h = len./n; % cell width in each direction
x = ax(1)+h(1)/2:h(1):ax(2)-h(1)/2; % x-coordinates of cell centers
y = ax(3)+h(2)/2:h(2):ax(4)-h(2)/2; % y-coordinates of cell centers
[X,Y] = meshgrid(x,y); % position matrices
C = c0(X,Y); % evaluate initial concentration field
cax = [min(min(C)),max(max(C))]; % fix color axes by initial conditions
dt = min(h)^2/4/d; % maximum admissible time step
nt = ceil(tf/dt); % number of time steps
dt = tf/nt; % actual time step

for j = 0:nt % time loop
    % Diffusion step (with no flux boundary conditions)
    if j>0 % If zeroth step, do not compute yet, but plot initial state
        C = C+dt*d*((C(:,[1 1:end-1])-2*C+C(:,[2:end end]))/h(1)^2+...
            (C([1 1:end-1],:)-2*C+C([2:end end],:))/h(2)^2);
    end
    % Plotting
    clf
    surf(X,Y,C)
    imagesc(x,y,C) % plot concentration field
    axis xy equal tight, caxis(cax)
    title(sprintf('Diffusion of concentration field at t = %0.1f',j*dt))
    xlabel('x'), ylabel('y')
    drawnow
end
