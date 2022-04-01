function temple_abm_opinion_dynamics
%TEMPLE_ABM_OPINION_DYNAMICS
%   Agents whose opinions affect each other. The
%   basic trend is that everybody is drawn to the
%   average opinion in their vicinity. The key
%   question is whether a global consensus is reached,
%   or whether instead multiple opinion clusters form.
%
% 04/2018 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

%------------------------------------------------------------------------
% Parameters
%------------------------------------------------------------------------
n = 30; % number of agents
r = .2; % radius of influence
ns = 100; % number of steps
mu = .1; % strength of attraction per step

% Initialization
x0 = rand(n,1); % initial opinions
X = x0*ones(1,ns+1); % data structure for results

% Computation
for i = 1:ns % time loop
    %--------------------------------------------------------------------
    % Plotting
    %--------------------------------------------------------------------
    clf
    plot(1:i,X(:,1:i)','.-')
    axis([1,ns,0,1])
    xlabel('step')
    ylabel('opinion')
    title('Temporal evolution of opinion dynamics')
    pause(1e-2)
    
    %--------------------------------------------------------------------
    % Update rule
    %--------------------------------------------------------------------
    a = zeros(n,1); % average opinion
    for j = 1:n % loop over agents
        dist = abs(X(:,i)-X(j,i)); % distance to other agents
        ind = 0<dist&dist<=r; % nearby agents
        if any(ind) % if at least one other agent is nearby
            a(j) = mean(X(ind,i)); % average of other agents' opinion
        else % if no other agents nearby agents
            a(j) = X(j,i); % use agent's opinion as attractor
        end
    end
    X(:,i+1) = X(:,i)+mu*(a-X(:,i)); % move opinion towards average
end
