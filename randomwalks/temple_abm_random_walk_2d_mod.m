function temple_abm_random_walk_2d_mod
%TEMPLE_ABM_RANDOM_WALK_2D_MOD
%   Random walkers in two space dimensions. Shown are two
%   different random walks. On the left, each step is drawn
%   from {-1,0,1}^2, i.e., each coordinate is modified by 1
%   up or down, or remains unchanged. On the right, each step
%   is drawn from [-1,1]^2, uniformly distributed, i.e., each
%   coordinate is modified by a random real smaller or equal
%   to 1. For each walker, a histogram of the final position is shown.
%   Only the last position of te random walk is stored, not the entire 
%   random walk histories. 
%
%  01/2022 by Rujeko Chinomona
%  Based on the code temple_abm_random_walk_2d by Benjamin Seibold

% Parameters
ns = 1000; % number of steps
N = 1e4; % number of trials
L = 60; % maximum extension of histogram
ax = linspace(-L,L,40); % bins for 2d histogram


X1store = zeros(N,2); % initialize matrix of final positions
X2store = zeros(N,2); % initialize matrix of final positions

% Do N trials of a random walk
for i = 1:N
    % Initialization
    X1 = [0,0]; % initial position of walker 1
    X2 = [0,0]; % initial position of walker 2
    for j = 1:ns % loop over steps
        % Random walk steps
        X1 = X1 + randi(3,1,2)-2; % adding random integer {-1,0,1}^2 to position
        X2 = X2 + rand(1,2)*2-1; % adding random real [-1,1]^2 to position
    end
    X1store(i,:) = X1;
    X2store(i,:) = X2;
end

% Plot histograms
clf
subplot(1,2,1) % left subplot
hist3(X1store,{ax,ax}) % plot 2d histogram of final position of random walk
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto') % add color
title('Random walk with integer steps \{-1,0,1\}^2')
xlabel('x'), ylabel('y') % axis labels

subplot(1,2,2) % right subplot
hist3(X2store,{ax,ax}) % plot 2d histogram of final position of random walk
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto') % add color
title('Random walk with real steps [-1,1]^2')
xlabel('x'), ylabel('y') % axis labels
