function temple_abm_cellular_game_of_life_file_ic
%TEMPLE_ABM_CELLULAR_GAME_OF_LIFE_FILE_IC
%   Implementation of the popular cellular automaton model
%   game of life by John Conway. A cell remains alive it it
%   has 2 or 3 live neighbors, and a dead cell becomes alive
%   if it has exactly 3 neighbors. Otherwise cells die or
%   remain dead. In this version, initial conditions are
%   read from data files (data format is as in
%   http://www.radicaleye.com/lifepage/glossary.html).
%   The present example needs the files
%   temple_abm_cellular_game_of_life_file_ic_blinker_ship.txt
%   temple_abm_cellular_game_of_life_file_ic_glider_gun.txt
%   to run. It shows a glider gun firing at a blinker ship.
%
% 03/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = [250,100]; % number of cells per dimension
filename{1} = 'temple_abm_cellular_game_of_life_file_ic_glider_gun.txt';
pos{1} = [5,5]; % position of object loaded from file (top corner)
filename{2} = 'temple_abm_cellular_game_of_life_file_ic_blinker_ship.txt';
pos{2} = [215,70]; % position of object loaded from file (top corner)

% Construct initial configuration
F = zeros(n); % initialize empty array
for j = 1:length(pos) % loop over objects
    S = load_data_file(filename{j}); % road data file
    F(pos{j}(1)+(1:size(S,1)),... % add object
        pos{j}(2)+(1:size(S,2))) = S; % to 2d array
end

% Initialization
n = size(F); % new size of domain (if necessary)
shl1 = [n(1),1:n(1)-1]; shr1 = [2:n(1),1]; % shift index vectors in dim 1
shl2 = [n(2),1:n(2)-1]; shr2 = [2:n(2),1]; % shift index vectors in dim 2

% Computation
clf
for j = 0:3000 % time loop
    % Plotting
    imagesc(~F') % plot array of cells
    axis equal tight, caxis([0,1]), colormap(gray)
    title(sprintf('Game of life after %d steps',j))
    pause(1e-2+(j==0)) % wait a bit (and a bit more initially)
    % Update rule
    neighbors = F(shl1,shl2)+F(shl1,:)+F(shl1,shr2)+... % number
        F(:,shl2)+F(:,shr2)+... % of neighbors
        F(shr1,shl2)+F(shr1,:)+F(shr1,shr2); % for each cell
    F = (F&(neighbors==2|neighbors==3))|... % cell remains alive
        (~F&neighbors==3); % or cell becomes alive
end

%========================================================================

function S = load_data_file(filename)
% Read the data file filename and assign the information in 2d array S.
fid = fopen(filename,'r'); % open data file for reading
data = double(fscanf(fid,'%c',inf)); % read data as single string
fclose(fid); % close file
data = [10,data,10]; % add space in beginning and end of string
ind_data = data==42|data==46; % indices where actual cell data is stored
i_start = find(diff(ind_data)==1); % beginning index of row
i_end = find(diff(ind_data)==-1); % beginning index of row
row_length = i_end(1)-i_start(1); % length of each row in data
data = data(ind_data); % remove non-cell information
data = data==42; % make data logical for cell states
S = reshape(data,row_length,[]); % object stored as 2d array
