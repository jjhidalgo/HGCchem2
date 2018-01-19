function [rhoavg_z,rhoavg_x] = rho_average(grid,par,conc)  

  r = rho(par,conc);
  
  xNz = zeros(grid.Nz,1);
  
  rhoavg_x = ([xNz r] + [r xNz])/2;
  
  if par.isPeriodic
    rhoavg_z = ([r(1,:); r] + [r; r(grid.Nz,:)])/2;
  else
    zNx = zeros(1,grid.Nx);
    rhoavg_z = ([zNx; r] + [r; zNx])/2;
  end
  

end
