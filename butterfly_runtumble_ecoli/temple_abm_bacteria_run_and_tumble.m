function temple_abm_bacteria_run_and_tumble
%TEMPLE_ABM_BACTERIAL_RUN_AND_TUMBLE
%   Multiple agents (representing E. coli bacteria) move
%   in a 2d concentration field (of, say, glucose). Their
%   motion is run-and-tumble, which means they terminate
%   their straight motion (and switch to a tumble) with a
%   probability that depends on whether the concentration
%   value is improving or not. In this model, the tumble
%   does not have any duration; it is an instantaneous
%   change of direction.
%
% 02/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
N = 200; % number of bacteria
ns = 5000; % number of random walk steps
p = [.1 .2]; % probability to tumble when walking uphill vs. downhill
c = @(x,y) max(max(150-sqrt((x-30).^2+(y-40).^2),... % concentration
    100-sqrt((x-120).^2+(y-100).^2)),0); % field
ax = [0 150 0 150]; % domain for plotting
X = [ax(1)+(ax(2)-ax(1))*rand(N,1),... % initial positions
    ax(3)+(ax(4)-ax(3))*rand(N,1)]; % of bacteria
D = rand(N,1)*2*pi; % initial angles of direction of bacteria

% Initialization
px = ax(1):ax(2); % x-vector for concentration field
py = ax(3):ax(4); % y-vector for concentration field
[PX,PY] = meshgrid(px,py); % generate 2d position matrices
C = c(PX,PY); % concentration field as 2d array
v = c(X(:,1),X(:,2)); % concentration values at bacteria positions
cax = [min(min(C)),max(max(C))]; % range of concentration values

for j = 1:ns % loop over steps
    % Update positions and concentration values
    X(:,1) = X(:,1)+cos(D); X(:,2) = X(:,2)+sin(D); % move bacteria
    v0 = v; % concentration values at previous positions
    v = c(X(:,1),X(:,2)); % concentration values at new positions

    % Update direction angles
    ind = rand(N,1)<p(2)+(p(1)-p(2))*(v-v0>0); % who is tumbling
    D(ind) = rand(nnz(ind),1)*2*pi; % assign new direction
    ind = (X(:,1)<ax(1)&cos(D)<0)|... % who is hitting a wall
        (X(:,1)>ax(2)&cos(D)>0); % horizontally
    D(ind) = pi-D(ind); % reverse x-direction
    ind = (X(:,2)<ax(3)&sin(D)<0)|... % who is hitting a wall
        (X(:,2)>ax(4)&sin(D)>0); % vertically
    D(ind) = -D(ind); % reverse y-direction
    
    % Plotting
    clf
    imagesc(px,py,C) % plot concentration field
    hold on
    plot(X(:,1),X(:,2),'k.','markersize',12) % plot positions of bacteria
    plot(X(:,1)-cos(D),X(:,2)-sin(D),'k.','markersize',4) % plot tails
    hold off
    axis equal xy, axis(ax), caxis(cax)
    xlabel('x'), ylabel('y') % axis labels
    title('Run-and-tumble of E. coli bacteria in concentration field')
    drawnow
end
