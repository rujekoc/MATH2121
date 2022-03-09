function temple_abm_ode_time_stepping
%TEMPLE_ABM_ODE_TIME_STEPPING
%   Comparison of three methods to approximate an
%   ordinary differential equation: Euler's method,
%   trapezoidal rule, and Runge-Kutta 4.
%
% 03/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
f = @(x) [0 -1;1 0]*x; % right hand side of ODE
tf = 4*pi; % final time
dt = 2e-1; % time step
x0 = [1;0]; % starting position
ax = [-1 1 -1 1]*2; % window for plotting

% Initialization
nt = ceil(tf/dt); % number of time steps
dt = tf/nt; % actual time step
phi = linspace(0,2*pi,400); cx = cos(phi); cy = sin(phi);

% Computation
X{1} = x0*ones(1,nt+1); X{2} = X{1}; X{3} = X{1}; % initialize data
for j = 1:nt % time loop
    % Euler method
    X{1}(:,j+1) = X{1}(:,j)+dt*f(X{1}(:,j));
    % Trapezoidal rule
    s1 = f(X{2}(:,j)); % first slope
    s2 = f(X{2}(:,j)+dt*s1); % second slope
    X{2}(:,j+1) = X{2}(:,j)+dt*(s1+s2)/2; % step with average slope
    % Runge-Kutta 4
    s1 = f(X{3}(:,j)); % first slope
    s2 = f(X{3}(:,j)+dt/2*s1); % second slope
    s3 = f(X{3}(:,j)+dt/2*s2); % third slope
    s4 = f(X{3}(:,j)+dt*s3); % fourth slope
    X{3}(:,j+1) = X{3}(:,j)+dt*(s1+2*s2+2*s3+s4)/6; % actual step
    % Plotting
    clf
    plot(cx,cy,'k:')
    hold on
    plot(X{1}(1,1:j+1),X{1}(2,1:j+1),'b.-',...
        X{2}(1,1:j+1),X{2}(2,1:j+1),'r.-',...
        X{3}(1,1:j+1),X{3}(2,1:j+1),'m.-')
    hold off
    axis equal, axis(ax)
    legend('true solution','Euler method',...
        'trapezoidal rule','Runge-Kutta 4')
    xlabel('x'), ylabel('y')
    drawnow
end
