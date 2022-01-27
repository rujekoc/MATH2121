% run random walks

N = 1e5;
nsteps = [15 30 45 60];

for ns=nsteps
  temple_abm_random_walk_1d(N,ns);
end
