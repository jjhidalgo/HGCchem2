function [grid, par, por,K, t,saveopt, restart] = hgc_initialize()
%
% Initializas grid, parameter, time, output options and restart options.
% Sets default values.
%
%
% Geometry 
%
grid.A = 0;
grid.Lx = 0;
grid.Lz = 0;
grid.angle = 0; %( in degrees);
grid.sin = 0;
grid.cos = 0;
grid.Nz = 0;
grid.Nx = 0;
grid.dx = 0;
grid.dz = 0;
grid.well = 0;
%
% Time
%
t.Tmax = 0.0;
t.Tpar = 0.0;
t.inj =  -1.0;  %injection from t=0 to t.inj
t.bomb = -1.0; % pumping begins at t.bomb
t.dt = 0;
t.iframe = 0;
t.ipost = 0;
t.npost = 1;  %do postprocess every Tpar/npost.
t.timesc = 0;
t.dt_custom = 1e99;
%
% Physical parameters
%
par.isPeriodic = false();
par.LeftIsDirichletFlow = false();
par.RightIsDirichletFlow = true();
par.LeftIsDirichletTpt = true();
par.RightIsDirichletTpt = false();
par.Ra = 0.0;
par.R = 0.0;
par.G = 1.0;
par.Pe = 0;
par.Np = 0;
par.denslaw = 0; %(1:PG+water; 2:Salt+water; 0: rho constant);
par.reactlaw = 0; %(0:None; 1:Calcite);
par.isReact = false();
par.isComp = false();
par.S = 0.;
par.cmax = 0;
par.displ = 0.00;
par.dispt = 0.0;
par.xini = 0.0; %initial position of the front.
par.noise = 0.0; %amplitud of noise in the to intial solution (0.01).
par.c0 = 0;
%
% Permeability
%
K.load = false();%
K.file = '';
K.isHet = false();
K.isReact = false();
K.kperm = 0;
%
% Porosity
%
por.ini = 0;
por.por = 0;
%
% Output options
%
saveopt.conc = 0; %(0:No, 1: Save; 2:Show on screen, 3:show&save). 
saveopt.vel = 0;
saveopt.por = 0;
saveopt.pres = 0;
saveopt.now = false();
saveopt.post = false();
saveopt.restart = true();
%
restart.do = false();
restart.Tmax = 0.0;
restart.file = '';
%
return