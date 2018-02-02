close all
clear all
%
% Initializes data structures with default values.
%
[grid, par, por,K, t,saveopt, restart] = hgc_initialize();
% Geometry 
%
grid.A = 1;     %A = Lx/Lz
grid.angle = 90; %( in degrees);
%
% Discretization
% (cells) 
% if Nx=0 then it is computed so that dx=dz.
%
grid.Nz = 100;
% (cells) 
% if Nx=0 then it is computed so that dx=dz.
%
if (grid.Nx==0)
  grid.Nx = round(grid.A*grid.Nz);
end
%
% Time
%
t.Tmax = 100.0; % maximum time
t.Tpar = 0.1;  % output interval
t.dt_custom = 1e99; % This time step is used if lower than the the authomatic.
%
% Physical parameters
%
par.Ra = 500;
par.R = 0.0;
par.G = 1.0;
par.denslaw = -2; %(1:PG+water; 2:Salt+water; 0: rho constant);
par.isComp = false();
par.S = 1.;
par.displ = 0.00;
par.dispt = 0.0;
par.xini = 0.5; %initial position of the front.
par.noise = 0.0; %amplitud of noise in the to intial solution (0.01).
%
% Boundary condtions
%
par.IsPeriodic = true(); %top and bottom
par.LeftIsDirichletFlow = false();
par.RightIsDirichletFlow = false();
par.LeftIsDirichletTpt = true();
par.RightIsDirichletTpt = true();
par.pL = 0;
par.pR = 0;
par.uL = 0;
par.uR = 0;
par.cL = 1.0;
par.cR = 0.0;
%
% Output options
%
saveopt.conc = 2; %(0:No, 1: Save; 2:Show on screen, 3:show&save). 
saveopt.vel = 0;
saveopt.pres = 0;
saveopt.por = 0;
%
restart.do = false();
restart.Tmax = 10.0;
restart.file = '';
%
[grid, par, por, K, restart] = hgc_default(grid, par, por, K, restart);
%
%
% Permeability
K.isHet = false();
K.load = false();
%K.var_lnk = 1.;
%K.corr_lenx = grid.dx;
%K.corr_lenz = grid.dx;
%K.kperm = compute_permeability(K,grid,par);
%K.kperm = ones(grid.Nz,grid.Nx);

%
% Initial condicitons
%
c = c_ini(grid,par); c=flipud(c);
p = zeros(size(c));
%
% Default values derived from given data.
% 
[telapsed] = gravitycurrent(grid,par,por,K,c,p,t,saveopt,restart);
%
disp('Elapsed time');
disp(strcat([num2str(telapsed/3600) 'hours']));
disp('End of simulation.');
%
return