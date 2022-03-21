function temple_abm_cellular_game_of_life
%TEMPLE_ABM_CELLULAR_GAME_OF_LIFE
%   Implementation of the popular cellular automaton model
%   game of life by John Conway. A cell remains alive it it
%   has 2 or 3 live neighbors, and a dead cell becomes alive
%   if it has exactly 3 neighbors. Otherwise cells die or
%   remain dead.
%
% 03/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = [100,50]; % number of cells per dimension

% Initialization
F = rand(n)<.1; % initial state array (random)
shl1 = [n(1),1:n(1)-1]; shr1 = [2:n(1),1]; % shift index vectors in dim 1
shl2 = [n(2),1:n(2)-1]; shr2 = [2:n(2),1]; % shift index vectors in dim 2

% Computation
clf
for j = 0:3000 % time loop
    % Plotting
    imagesc(~F') % plot array of cells
    axis equal tight, caxis([0,1]), colormap(gray)
    title(sprintf('Game of life after %d steps',j))
    pause(1e-1+(j==0)) % wait a bit (and a bit more initially)
    % Update rule
    neighbors = F(shl1,shl2)+F(shl1,:)+F(shl1,shr2)+... % number
        F(:,shl2)+F(:,shr2)+... % of neighbors
        F(shr1,shl2)+F(shr1,:)+F(shr1,shr2); % for each cell
    F = (F&(neighbors==2|neighbors==3))|... % cell remains alive
        (~F&neighbors==3); % or cell becomes alive
end
