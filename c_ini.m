function c = c_ini(grid,par)
%
% Computes initial concentration.
%
  x = grid.dx:grid.dx:grid.Lx;
  z = grid.dz:grid.dz:grid.Lz;
  [xx, zz] = meshgrid(x,z); 
  %pos = 1/par.Ra*exp(par.R/2);%rand(size(zz));
  %pos = 0.05*grid.A;
  %c = 0.5*(1-erf((xx-10/grid.Nx-pos)*sqrt(12*grid.Nx)));
  %c = 0.5*(1-erf((xx-10/grid.Nx-pos)*sqrt(grid.Nx)));
  c = (1-tanh(100*(xx-par.xini)))/2;
  
  if par.noise>0
    ix = find(c>0.1 & c<0.99);
    c(ix) = c(ix)+par.noise*rand(size(ix));
  end
%
end
