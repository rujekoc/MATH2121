function temple_abm_cellular_rule184
%TEMPLE_ABM_CELLULAR_RULE184
%   Binary cellular model in 1d with immediate neighbor
%   interaction only. This particular example implements
%   rule 184, which reads as:
%   current pattern   111 110 101 100 011 010 001 000
%   new state          1   0   1   1   1   0   0   0
%
% 03/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = 90; % number of agents

% Initialization
x = rand(1,n)<.5; % about 1 in 10 agents is initially infected

% Computation
for j = 1:800 % time loop
    % Plotting
    fprintf('%d',x)
    fprintf('\n')
    % Update rule
    x = (~x&x([end 1:end-1]))|(x&x([2:end 1]));
    pause
end
