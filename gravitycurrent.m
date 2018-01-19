function [telapsed]=gravitycurrent(grid,par,por,K,c,p,t,saveopt,restart)
%
% grid
%  Nx    --> Cells in x direction
%  Nz    --> Idem z direction
%  Lx
%  Lz
%  A       --> Lx/Lz.
%
% par
%   Pe    --> Peclet number
%   R     --> Mobility ratio R = log(mu2/mu1). Fluid 1 up, fluid 2 down.
%   denslaw --> Density law. 1:PG+water; 2:Salt+water;
%
% K (permeability)
%  isHet
%  var_lnk 
%  corr_lenx 
%  corr_lenz 
%
% t
%   Tmax  --> Simulation time 
%   Tpar  --> Data saved and pictured every Tpar secs
%
% c    --> Initial concentration (then concentration at any time).
%
% saveopts
%   conc -->  Saves concentration data (0:No, 1: Yes; 2:Show on screen, 3:show&save).
%   vel  -->  Saves velocity data (0:No, 1: Yes; 2:Show on screen, 3:show&save)
%
tic;
tstart = tic;
%
% Differentiation matrices for the CDs
%
[Ax,Bx,Axx,Bxx] = CD_matrices(grid.Nx,grid.Lx/(grid.Nx-1),false());
%
[Az,Bz,Azz,Bzz] = CD_matrices(grid.Nz,grid.Lz/(grid.Nz-1),par.isPeriodic);
%
% Auxiliar strings
%
strR = num2str(par.R);
strRa = num2str(par.Ra);
%
% Matrices and scalars initialization
%
ux = zeros(size(c));
uz = zeros(size(c));
umax = 0;
%
post_res = [];
%
if (restart.do)
  
  [time,t,c,p,ux,uz,umax,por,K] = restart_simulation(restart);

else

  Nframes = floor(t.Tmax/t.Tpar) + 1;  
    
  t.time = zeros(1,Nframes);
  t.time(t.iframe+1) = 0;
  
  saveopt.now = true();
  saveopt.post = true();
  save_data(saveopt,grid,par,por,K,t,c,p,ux,uz,restart);
  %[post_res] = postprocess(c,t,grid,par,post_res);
  pos_res = 1;

  [t, saveopt] = time_update(t,grid,par,por,saveopt,umax);
  
end
%
is_first_time = true();
%
% Time loop
%
dcdt = 0;
while t.timesc <= t.Tmax
     
     if (par.isComp)
       dcdt = c; %stores c in time k to compute the derivative later
     end

     c = transport(par,por,t,c,ux,uz,Az,Azz,Bz,Bzz,Ax,Axx,Bx,Bxx);
     
     if (par.isComp)
       dcdt = (c-dcdt)/t.dt; %(c(k+1)-c(k))/dt
     end

     if (K.isReact)
       por.por = porosity(par,por,c,t,Ax,Bx,Az,Bz,ux,uz);
       K.kperm = permeability(por);
     end
%
% Computes flow matrix when viscosity is not constant
% and solves for pressure and velocity.
% If viscosity is constant, flow matrix is computed just once.
%
    if (abs(par.R)>0 || K.isReact || is_first_time)
        [Am,Trans] = p_matrix(grid,par,K,c);
        [ux,uz,p] = p_rhs(grid,par,c,Am,Trans,t,p,dcdt);
        is_first_time = false();
    else
      [ux,uz,p] = p_rhs(grid,par,c,Am,Trans,t,p,dcdt);
    end

    umax = max(max(sqrt(ux.^2 + uz.^2)));
%
% Saves output
%
    if (saveopt.now)
        
        save_data(saveopt,grid,par,por,K,t,c,p,ux,uz,restart);
        %[post_res] = postprocess(c,t,grid,par,post_res);
        
        t.time(t.iframe+1) = t.timesc;
        disp(strcat(['time = ' num2str(t.timesc)]));

    end
    
    if (saveopt.post && ~saveopt.now)
     
      % edit this function to customize postprocess.
      % [post_res] = postprocess(c,t,grid,par,post_res);     

    end
%
% Updates time step value
%
    [t, saveopt] = time_update(t,grid,par,por,saveopt,umax);
    
end % while

  telapsed = toc(tstart); %Computation time 

  cfile = strcat('Ra',strRa,'-R',strR,'.mat');

  time = [t.time];
  save(cfile,'grid','time','telapsed','t','par','K');
    
  save(restart.file,'ux','uz','umax','por','K','t','c','p'); 

  %save_postprocess(c,t,grid,par,post_res);
  
end %function
