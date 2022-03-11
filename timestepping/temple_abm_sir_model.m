function temple_abm_sir_model
%TEMPLE_ABM_SIR_MODEL
% Euler's Method applied to SIR model for disease spread with equations
% s'(t) = -b*s(t)*i(t) (susceptible fraction of total population)
% i'(t) = b*s(t)*i(t) - k*i(t) (infected fraction of total population) 
% r'(t) = k*i(t)   (recovered fraction of total population) 
% b - rate of infection
% k - rate of recovery
%
% 
% Rujeko Chinomona 
% 03/2022

% model parameters 
b = 1/2; % rate of infection
k = 1/3; % rate of recovery

% time variables 
tf = 150;  % final time 
dt = 15;   % step size 
t = 0:dt:tf; % solution times 
n = length(t); % number of steps plus 1

% Initialization
s = zeros(n,1); % susceptible 
i = zeros(n,1); % infected
r = zeros(n,1); % recovered 

% Initial conditions, approximately add up to 1. 
s(1) = 1; 
i(1) = 1.27e-6;
r(1) = 0;

% Time loop 
for j = 2:n
    % Approximate the solution using Euler's Method
    s(j) = s(j-1) - dt*b*s(j-1)*i(j-1);
    i(j) = i(j-1) + dt*(b*s(j-1)*i(j-1) - k*i(j-1)); 
    r(j) = r(j-1) + dt*(k*i(j-1)); 
end

% Plot all solutions on the same figure 
clf 
plot(t,s,'k-',t,i,'b-',t,r,'g-')
legend('s(t)','i(t)','r(t)')
hold on 

    