function temple_abm_random_walk_annealing
%TEMPLE_ABM_RANDOM_WALK_ANNEALING
%   Random walk in 1d with a probability of rejecting an
%   undesirable step. The rejection probability depends
%   on a background function, and it increases in time.
%   This is an example of the "simulated annealing"
%   technique, here used to find the global minimum of
%   a function with multiple local minima.
%
% 01/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
f = @(x) 3+.05*x.^2-.4*x+sin(1.5*x)+.3*cos(5*x); % given function
ax = [-10,10]; % interval of interest
ns = 1000; % number of random walk steps
w = .5; % standard deviation of each random walk step

% Initialization
px = linspace(ax(1),ax(2),400); % x-values for plotting of function
pf = f(px); % corresponding function values
x = sum(ax)/2; % starting position (middle of interval)
v = f(x); % corresponding value

% Perform random walk
for j = 1:ns % loop over steps
    % Random walk step
    q = (1-j/ns)^4; % probability to accept an upward step
    for i = 1:1e4 % conduct finitely many attempts for an accepted step
        xnew = x(end)+w*randn; % perform random step
        vnew = f(xnew); % evaluate new value
        if xnew>=ax(1)&&xnew<=ax(2)&&... % accept only if inside interval
            (vnew<v(end)||... % and: new value is lower,
            rand>1-q) % or higher with a certain probability
            x(end+1) = xnew; % append position vector with new position
            v(end+1) = vnew; % append value value with new value
            break
        end
    end
    
    % Plot function and random walk
    clf
    plot(ax,ax*0,'k-',px,pf,'b-') % plot function
    hold on
    plot(x,v,'r.') % plot visited points
    plot(x(end)*[1 1],[0 v(end)],'k.-') % plot current state
    hold off
    xlabel('x'), ylabel('f(x)') % axis labels
    title(sprintf(['Annealing step %d/%d. Value:%8.5f. ',...
        'Accept upward step with p=%0.5f'],j,ns,v(end),q))
    pause(1e-3)
end
