function temple_abm_mexican_wave_alternative
%TEMPLE_ABM_MEXICAN_WAVE_ALTERNATIVE
%   Model for a Mexican wave in a sports stadium, generated by
%   spectators who stand up and sit down to create the wave as
%   an emergent structure. The provided model is very simple
%   and should be improved. Model: 0=sitting; 1=standing.
%   Update rule: if sitting and left neighbor standing, then
%   stand up; if standing, then sit down.
%
%   This file does the same as TEMPLE_ABM_MEXICAN_WAVE,
%   however in an alternative fashion: the update rule is done
%   in a non-vectorized fashion, and plotting is done
%   graphically.
%
% 01/2016 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
n = 40; % number of agents

% Initialization
x = double(1:n==round(n/3)); % a single agent is standing up

% Computation
for j = 1:80 % time loop
    % Plotting
    clf
    plot(1:n,x,'*-')
    % Update rule
    x0 = x; % create a copy of state vector
    xs = x([end 1:end-1]); % right-shifted copy of state vector
    for i = 1:n % loop over state vector elements
        if x0(i)==0&&xs(i)==1 % if 0 & left neighbor 1,
            x(i) = 1; % become 1
        elseif x0(i)==1 % if 1,
            x(i) = 0; % become 0
        end
    end
    pause
end
