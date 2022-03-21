function temple_abm_cellular_crowd
%TEMPLE_ABM_CELLULAR_CROWD
%   Model for the dynamics of a 2d crowd, using a cellular
%   description. A cell can be empty (state 0), or occupied
%   by an agent of type 1 or an agent of type 2. Type 1
%   agents wish to walk to the right, while type 2 agents
%   wish to walk to the left. In each step, agents are
%   addressed one after another in a cyclic fashion. Each
%   agent attempts to conduct a step in their desired
%   direction. If that cell is occupied, they attempt a
%   step in a random direction. If that cell is occupied,
%   they stand still.
%
% 04/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = [200,75]; % number of cells per dimension

% Initialization
F = max(ceil(5*rand(n)-3),0); % initial state array (randomly 0, 1, or 2)
legal = @(r,c) 1<=r&r<=n(1)&1<=c&c<=n(2); % legal positions to walk to

% Computation
clf
for j = 0:2000 % time loop
    % Plotting
    imagesc(F') % plot array of cells
    axis equal tight, caxis([0,2]), colormap(jet)
    title(sprintf('Crowd dynamics after %d steps',j))
    pause(1e-2) % wait a bit
    
    % Update rule
    ind = find(F>0)'; % indices of cells with an agent in them
    ind = ind(randperm(length(ind))); % randomly reorder indices
    for i = ind % loop over all agents
        [ir,ic] = ind2sub(n,i); % row and column of this cell
        dr = ir+(3-2*F(i)); dc = ic; % desired row and column
        if legal(dr,dc) % if desired position legal
            if F(dr,dc)==0 % if desired cell empty
                F(dr,dc) = F(i); % assign agent to new desired cell
                F(i) = 0; % remove agent from current cell
            end
        end
        if F(i)>0 % if agent had not been move previously
            dr = ir+(randi(3)-2); dc = ic+(randi(3)-2); % random step
            if legal(dr,dc) % if desired position legal
                if F(dr,dc)==0 % if desired cell empty
                    F(dr,dc) = F(i); % assign agent to new desired cell
                    F(i) = 0; % remove agent from current cell
                end
            end
        end
    end
end
