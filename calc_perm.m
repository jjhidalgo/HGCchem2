function [kperm, var_lnk_actual] = calc_perm(grid,K)

  Lx = grid.Lx;
  Lz = grid.Lz;
  Nx = grid.Nx;
  Nz = grid.Nz;
  
  kx = (2*pi/Lx)*[0:(Nx/2-1) (-Nx/2):(-1)]';
  kz = (2*pi/Lz)*[0:(Nz/2-1) (-Nz/2):(-1)]';
  [KX,KZ] = meshgrid(kx,kz);
  KX2 = KX.^2;
  KZ2 = KZ.^2;

  [kperm, var_lnk_actual] = gen_randperm(K.corr_lenx, K.corr_lenz, KX2, KZ2);
end
