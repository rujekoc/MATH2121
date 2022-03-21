function temple_abm_traffic_cellular
%TEMPLE_ABM_TRAFFIC_CELLULAR
%   Cellular automaton model for vehicular traffic flow.
%   Implemented is the Nagel-Schreckenberg model. Each cell
%   carries a number. 0 means the cell is unoccupied, while
%   a positive number means that a vehicle occupies the
%   cell, and the vehicle speed is one less than the value
%   stored.
%
% 03/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = 500; % number of cells
p = 0.5; % probability of velocity reduction
v_max = 6; % maximum velocity

% Initialization
x = double(mod(1:n,8)==0); % place cars equidistantly and at rest initially

% Computation
for j = 1:1000 % time loop
    % Plotting
    cp = find(x>0); % vehicle positions
    clf
    plot([1;1]*(0:n),[-2;0]*ones(1,n+1),'k-',... % plot cells
        [0;n]*[1,1],[1;1]*[-2,0],'k-')
    hold on
    plot(cp-.5,cp*0-1,'r.',... % plot cars
        cp-.5,x(cp)-1,'b.:','markersize',12) % and plot velocities
    hold off
    axis([0,n,-3,v_max+1])
    title(sprintf('Nagel-Schreckenberg model after %d steps',j))
    xlabel('position'), ylabel('velocity')
    pause(1e-2) % wait a bit
    % Update rule (5 steps)
    % Acceleration (all cars have velocity increased by 1)
    x(x>0) = min(x(x>0),v_max)+1;
    % Slowing down (reduce velocity to number of free cells ahead)
    ind_car = find(x>0); % indices of cells with a car in them
    headway = diff([ind_car,ind_car(1)+n])-1; % number of void cells ahead
    xi = x(ind_car); % values of cell with cars in them
    xi = min(xi,headway+1); % reduce velocity to headway
    % Randomization (with probability p, reduce car velocity by 1)
    xi = max(xi-(rand(size(xi))<p),1); % reduce velocity randomly
    % Car motion (move each car forward according to its speed)
    ind_new = mod(ind_car+xi-2,n)+1; % new car indices
    % Create new state vector
    x = x*0; x(ind_new) = xi; % assign values to new car positions
end
