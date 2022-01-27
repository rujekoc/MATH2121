function temple_abm_random_walk_levy_histogram
%TEMPLE_ABM_RANDOM_WALK_LEVY_HISTOGRAM
%   Random walk in two space dimensions, with log-normally
%   distributed step length (and uniformly distributed angle).
%   This is an example of a Levy flight, a random walk with
%   heavy-tailed step lengths. Conducted are several samples
%   of the random walk with several steps. The 2d histogram
%   of the final positions is plotted.
%
% 01/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
N = 1e5; % number of samples
ns = 100; % number of steps of random walk
L = 60; % maximum extension of histogram

% Initialization
ax = linspace(-L,L,40); % bins for 2d histogram
X = zeros(N,2); % initialize matrix of positions
for j = 1:ns % loop over steps
    dist = exp(randn(N,1)); % distance stepped (log-normal distribution)
    phi = rand(N,1)*2*pi; % random angle to step into
    X = X+[dist.*cos(phi),dist.*sin(phi)]; % add random step to position
end

% Plotting
clf
hist3(X,{ax,ax}) % plot 2d histogram of final position of random walk
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto') % add color
title(sprintf(['Histogram of position of random walk (%d steps) ',...
    'with log-normal steps (Levy flight)'],ns))
xlabel('x'), ylabel('y') % axis labels
