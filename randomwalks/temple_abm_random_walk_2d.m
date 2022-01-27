function temple_abm_random_walk_2d
%TEMPLE_ABM_RANDOM_WALK_2D
%   Random walkers in two space dimensions. Shown are two
%   different random walks. On the left, each step is drawn
%   from {-1,0,1}^2, i.e., each coordinate is modified by 1
%   up or down, or remains unchanged. On the right, each step
%   is drawn from [-1,1]^2, uniformly distributed, i.e., each
%   coordinate is modified by a random real smaller or equal
%   to 1. For each walker, the whole path is shown.
%
% 01/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
ns = 1000; % number of steps

% Initialization
X1 = [0,0]; % initial position of walker 1
X2 = [0,0]; % initial position of walker 2

% Computation
for j = 1:ns % loop over steps
    % Random walk steps
    X1(end+1,:) = X1(end,:)+... % append position matrix of walker 1 by
        randi(3,1,2)-2; % adding random integer {-1,0,1}^2 to position
    X2(end+1,:) = X2(end,:)+... % append position matrix of walker 1 by
        rand(1,2)*2-1; % adding random real [-1,1]^2 to position
    L = max(max(abs([X1,X2]))); % size of axis window
    
    % Plot paths of walkers
    clf
    subplot(1,2,1) % left subplot
    plot(X1(:,1),X1(:,2),'b.-',X1(end,1),X1(end,2),'ko')
    axis equal, axis([-1 1 -1 1]*L) % axis boundaries
    title('Random walk with integer steps \{-1,0,1\}^2')
    xlabel('x'), ylabel('y') % axis labels
    subplot(1,2,2) % right subplot
    plot(X2(:,1),X2(:,2),'r.-',X2(end,1),X2(end,2),'ko')
    axis equal, axis([-1 1 -1 1]*L) % axis boundaries
    title('Random walk with real steps [-1,1]^2')
    xlabel('x'), ylabel('y') % axis labels
    pause(1e-2)
end
