function temple_abm_diffusion_micro_vs_macro
%TEMPLE_ABM_DIFFUSION_MICRO_VS_MACRO
%   Comparison of random walker positions vs. a macroscopic
%   diffusion process. Plotted on the left is the histogram
%   of positions of a large number of random walkers, all
%   starting in the origin. On the right is the field of a
%   quantity that is initially all concentrated in the
%   center cell and then diffuses. One can see the agreement
%   of the resulting two plots.
%
% 02/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
L = 10; % extension of domain in each direction
N = 1e5; % number of agents (random walkers)
ns = 40; % number of steps

% Initialization
P = zeros(N,2); % initial position of agents (all in origin)
x = -L:L; % x-coordinates of cell centers
y = -L:L; % y-coordinates of cell centers
[X,Y] = meshgrid(x,y); % position matrices
C = X*0; C(1+L,1+L) = N; % all initial concentration in middle cell

for j = 0:ns % loop over steps
    % Computation
    if j>0 % If zeroth step, do not compute yet, but plot initial state
        P = P+randn(N,2)/2; % move agents
        C = C+1/8*(C(:,[1 1:end-1])-2*C+C(:,[2:end end])+... % diffusion
            C([1 1:end-1],:)-2*C+C([2:end end],:)); % step
    end
    % Plotting
    clf
    subplot(1,2,1)
    hist3(P,{x,y}) % histogram of agent positions
    set(get(gca,'child'),'FaceColor','interp','CDataMode','auto') % color
    view(0,90) % look from top
    axis equal tight
    title(sprintf('Histogram of agent positions after %d steps',j))
    xlabel('x'), ylabel('y')
    subplot(1,2,2)
    imagesc(x,y,C) % plot concentration field
    axis xy equal tight
    title(sprintf('Diffusion of concentration field after %d steps',j))
    xlabel('x'), ylabel('y')
    pause(1e-2)
end
