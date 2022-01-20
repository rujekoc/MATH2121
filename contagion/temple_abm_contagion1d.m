function temple_abm_contagion1d
%TEMPLE_ABM_CONTAGION1D
%   Model for a contagion process of agents aligned one-
%   dimensionally (with periodic wrap-around). This is a
%   simple example for a process that involves randomness.
%   Model: 0=healthy; 1=infected. Update rule: if infected,
%   stay so; if healthy and at least one neighbor infected,
%   get infected with probability p (per infected neighbor).
%   This model can be interpreted as describing a disease
%   spread, but also other things, such as rumors.
%
% 01/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = 60; % number of agents
p = .25; % probability of contagion spread to neighboring cell (per step)

% Initialization
x = rand(1,n)>1-.1; % about 1 in 10 agents is initially infected

% Computation
for j = 1:80 % time loop
    % Plotting
    fprintf('%d',x)
    fprintf('\n')
    % Update rule
    ifl = ~x&x([end 1:end-1]); % indices of possible contagion from left
    ifr = ~x&x([2:end 1]); % indices of possible contagion from right
    x(ifl) = rand(1,sum(ifl))>1-p; % contagion spread from left
    x(ifr) = rand(1,sum(ifr))>1-p; % contagion spread from right
    pause
end
