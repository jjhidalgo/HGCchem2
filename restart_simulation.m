function [time,t,c,p,ux,uz,umax,por,K] = restart_simulation(restart)

  load(restart.file);
  
% updates frame counter and maximum time
  last_frame = floor(t.timesc/t.Tpar) + 1;
  t.iframe = last_frame;
  t.ipost = t.iframe/t.npost;
  t.Tmax = restart.Tmax;
%
% Populates time vector with already computed times
  Nframes = floor(t.Tmax/t.Tpar) + 1;
  time = zeros(1,Nframes);
  time(1:last_frame) = 0:t.Tpar:(last_frame-1)*t.Tpar;
%
end
