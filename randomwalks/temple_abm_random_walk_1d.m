function temple_abm_random_walk_1d(N,ns)
  % TEMPLE_ABM_RANDOM_WALK_1D
  % INPUTS: N  - number of trials
  %         ns - number of steps per trial
  %   Random walker in one space dimension. In each time step,
  %   each walker steps either one step up or one step down
  %   (i.e., its position is increased or decreased by 1).
  %
  % OUTPUT: histogram of walker's final position
  %
  % 01/2022 by Rujeko Chinomona @ Temple University
  %

  % Parameters
  step = [-1 1];
  lastpos=zeros(N,1);                 % storage for last positions

  % Loop over N trials
  for k = 1:N
    x=0;                              % walker starts at zero
    % Execute random walk
    for j = 1:ns
      x = x + step(randperm(2,1));    % move up or down one step
    end
    lastpos(k) = x;                   % store last position of walker
  end

  clf
  histogram(lastpos)
  title(['Steps=',num2str(ns)]);
  print(['randomwalk1d_',num2str(N),'steps_',num2str(ns)],'-dpng'); % save figure

end
