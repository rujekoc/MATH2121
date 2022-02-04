function temple_abm_butterfly_corridor_width_mod
  %TEMPLE_ABM_BUTTERFLY_CORRIDOR_WIDTH_MOD
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
  %   This code computes the paths of 50 butterflies and
  %   outputs the total number of patches visited (by any
  %   butterfly) and the mean path length. The corridor
  %   width is then the ratio of those two values.
  %   [note: whether this is a good "definition" of
  %   corridor width is debatable.]
  %
  %  Based on temple_abm_butterfly_corridor_width by Benjamin Seibold (02/2016)
  %            http://www.math.temple.edu/~seibold/
  %
  %  02/2022 by Rujeko Chinomona
  %  This code tests out several different values of q, and generates
  %  corresponding corridor widths. Output a plot of Corridor width vs. q.


  % Parameters
  N = 50; % number of butterflies
  q = 0.1:0.1:1; % probability to move to neighbor cell with highest elevation
  cw = zeros(length(q),1);
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
  
  for k = 1:length(q)
    V = false(size(PX)); % 2d array which cells have been visited
    xf = zeros(N,2); % array for final positions of butterflies
    % Simulation of random walks
    for i = 1:N % loop over number of butterflies
        x = x0; % set initial position
        while 1 % loop over steps
            % Nearby elevation and stopping criterion
            nf = f(x(1)+rx,x(2)+ry); % elevation of neighboring cells
            [val,ind] = max(nf); % value and index with highest elevation
            if val<f(x(1),x(2)) % if current cell is higher than all
                break % neighboring cell (hill top), stop random walk
            end
            if rand<1-q(k) % with probability 1-q,
                ind = randi(8); % choose random index for neighbor cell
            end % (otherwise, the highest elevation had been chosen before)
            x = x+[rx(ind),ry(ind)]; % take step to neighbor cell
            V(ax(1)+1+x(2),ax(3)+1+x(1)) = true; % activate current cell
        end
        xf(i,:) = x; % store final position
    end

    % Compute quantities of interest
    nr_visited_cells = nnz(V); % number of cells visited by any butterfly
    dist = sqrt(sum((xf-ones(N,1)*x0).^2,2)); % vector of all distances
    avg_dist = mean(dist); % average distances traveled
    corridor_width = nr_visited_cells/avg_dist; % width of corridor
    cw(k) = corridor_width;
    
  end

  % Plotting
  plot(q,cw,'bo')
  xlabel('q'), ylabel('Corridor width')
  xlim([0 1])
