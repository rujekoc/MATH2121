function temple_abm_kde
%TEMPLE_ABM_KDE
%   Three ways of constructing a density field from point
%   positions: (a) histogram (i.e., piecewise constant)
%   via Matlab's hist3; (b) histgram by hand; and
%   (c) kernel density estimation via Gaussian kernels
%   (i.e., smooth).
%
% 02/2018 by Benjamin Seibold
%            http://www.math.temple.edu/~seibold/

% Parameters
N = 2e4; % number of points (agents)
nch = 20; % number of histogram cells in each dimension
nck = 50; % number of cell in each dimension for KDE
w = 3/nck; % kernel width
P = [.1+.7*rand(N,1),.4+randn(N,1)/5]; % position of points (non-uniform)

% Initialization
h = 1/nch; % cell size for histogram
xb = 0:h:1; % x-coordinates of cell boundaries
yb = xb; % y-coordinates of cell boundaries
x = h/2:h:1-h/2; % x-coordinates of cell centers
y = x; % y-coordinates of cell centers
hk = 1/nck; % cell size of KDE
xk = hk/2:hk:1-hk/2; % x-coordinates of cell centers for KDE
yk = xk; % y-coordinates of cell centers for KDE
[XK,YK] = meshgrid(xk,yk); % position matrices

% Compute histogram by hand
H = zeros(nch,nch);
for jx = 1:nch % loop over
    for jy = 1:nch % all cells
        H(jy,jx) = sum(xb(jx)<P(:,1)&P(:,1)<=xb(jx+1)&...
            yb(jy)<P(:,2)&P(:,2)<=yb(jy+1));
    end
end

% Compute kernel density estimate based on Gaussians
K = XK*0;
fac = 1/pi/w^2/N; % scaling factor of Gaussian
for j = 1:N % loop over agents
    K = K+fac*exp(-(((XK-P(j,1))/w).^2+((YK-P(j,2))/w).^2));
end

% Plotting
clf
% Plot markers
subplot(2,2,1)
plot(P(:,1),P(:,2),'k.','MarkerSize',1)
axis equal, axis([0 1 0 1])
title('Point positions')
xlabel('x'), ylabel('y')

% Plot histogram (using hist3)
subplot(2,2,2)
hist3(P,{x,y}) % histogram of point positions
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto') % color
view(0,90) % look from top
axis equal, axis([0 1 0 1])
title('Histogram')
xlabel('x'), ylabel('y')

% Plot histogram by hand
subplot(2,2,3)
imagesc(x,y,H)
axis xy equal, axis([0 1 0 1])
title('Histogram by hand')
xlabel('x'), ylabel('y')

% Plot kernel density estimate
subplot(2,2,4)
imagesc(xk,yk,K)
axis xy equal, axis([0 1 0 1])
title('Kernel density')
xlabel('x'), ylabel('y')
