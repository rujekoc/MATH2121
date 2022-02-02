function temple_abm_bacteria_run_and_tumble_and_eat
%TEMPLE_ABM_BACTERIAL_RUN_AND_TUMBLE_AND_EAT
%   Multiple agents (representing E. coli bacteria) move
%   in a 2d concentration field (of, say, glucose). Their
%   motion is run-and-tumble, which means they terminate
%   their straight motion (and switch to a tumble) with
%   a probability that depends on whether the
%   concentration value is improving or not. In this
%   model, the tumble does not have any duration; it is
%   an instantaneous change of direction.
%   In addition to moving, each agent also consumes a
%   certain amount of the concentration field in its
%   vicinity (if available). Once in a while, an extra
%   blob of concentration is added.
%
% 02/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
N = 250; % number of bacteria
ns = 5000; % number of random walk steps
p = [.05 .5]; % probability to tumble when walking uphill vs. downhill
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
cax = [min(min(C)),max(max(C))+eps]; % range of concentration values

for j = 1:ns % loop over steps
    % Update positions and concentration values
    X(:,1) = X(:,1)+cos(D); X(:,2) = X(:,2)+sin(D); % move bacteria
    v0 = v; % concentration values at previous positions
    v = interp2(px,py,C,X(:,1),X(:,2)); % evaluate field on bacteria

    % Update direction angles
    ind = rand(N,1)<p(2)+(p(1)-p(2))*(v-v0>0); % who is tumbling
    D(ind) = rand(nnz(ind),1)*2*pi; % assign new direction
    ind = (X(:,1)<ax(1)&cos(D)<0)|... % who is hitting a wall
        (X(:,1)>ax(2)&cos(D)>0); % horizontally
    D(ind) = pi-D(ind); % reverse x-direction
    ind = (X(:,2)<ax(3)&sin(D)<0)|... % who is hitting a wall
        (X(:,2)>ax(4)&sin(D)>0); % vertically
    D(ind) = -D(ind); % reverse y-direction
    
    % Update concentration field
    for i = 1:N % loop over agents to have them consume field
        L = .1*exp(-.05*((PX-X(i,1)).^2+... % local influence
            (PY-X(i,2)).^2)); % of this bacterium
        C = max(C-L,0); % reduce concentration by local influence
    end
    if rand<.01 % with a small probability, add blob of extra food
        C = C+100*exp(-.005*((PX-ax(1)-(ax(2)-ax(1))*rand).^2+...
            (PY-ax(3)-(ax(4)-ax(3))*rand).^2));
    end
    
    % Plotting
    clf
    imagesc(px,py,C) % plot concentration field
    hold on
    plot(X(:,1),X(:,2),'k.','markersize',12) % plot positions of bacteria
    plot(X(:,1)-cos(D),X(:,2)-sin(D),'k.','markersize',4) % plot tails
    axis equal xy, axis(ax)
    caxis(cax)
    xlabel('x'), ylabel('y') % axis labels
    title('E. coli bacteria moving in and consuming concentration field')
    drawnow
end
hold off
