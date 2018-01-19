function [grid,par,por,K,restart] = hgc_default(grid,par,por,K,restart)
%
% Sets default values for geometry, parameters,
% saving options, etc.
%
% Geometry 
%
grid.Lx = grid.A;
grid.Lz = 1;
grid.sin = sin((pi/180) * grid.angle);
grid.cos = cos((pi/180) * grid.angle);
%
% Discretization
%
grid.dx = grid.Lx/grid.Nx;
grid.dz = grid.Lz/grid.Nz;
%
% Physical parameters
%
par.cmax = cmax_visc(par.denslaw);
par.Pe = par.G*par.Ra; % just to check that dt and dx are OK
par.isReact = K.isReact;
%
% Porosity
por.ini = ones(grid.Nz,grid.Nx);
por.por = por.ini;
%
% Permeability
K.kperm = ones(grid.Nz,grid.Nx);
%
if (isempty(restart.file)) %default option in case you feel lazy.
  restart.file  = strcat(['Ra' num2str(par.Ra) '-R' num2str(par.R),'-restart.mat']);
end
%
return