function fields_OK = GenerateKfields(Nx,A,Variance,Nfields)
%
  grid.A = A;
%
  grid.Lx = 1;
  grid.Lz = grid.A;
%
% Discretization
% (cells = nodes-1)
%
%length = 22.5/2.5399; %inches
%dots = length*1000; %dpi (<=> Nx)
%grid.Nx = dots;
  grid.Nx = Nx;
  grid.Nz = round(grid.A*grid.Nx);
  grid.h = 1/grid.Nx;
%
  K.load = true();%
  K.file = '';
  K.isHet = true();
  K.var_lnk = 1;
  K.corr_lenx = grid.Lx/10; %in grid units
  K.corr_lenz = K.corr_lenx/10;  %in grid units
% They are now converted to the parameters
% the permeability generator needs.
  K.corr_lenx = K.corr_lenx/6;
  K.corr_lenz = K.corr_lenx/10;
%
  system('mkdir Kfields');
  std_dev = sqrt(Variance);

  for ifield=1:Nfields
  
    kfile = strcat(['./Kfields/K-' addzeros(ifield) '.mat']);
  
    [kperm var_lnk_actual] = calc_perm(grid,K);
    %load(kfile);
    K.file = kfile;
    
    lk = zscore(log(kperm));
    %scales K = exp( log(mean) + std_dev**Field)
    kperm = exp(std_dev*lk);
    K.var_lnk = Variance;
  
    save(K.file,'K', 'grid','kperm');
  
    if (mod(ifield,10)==0)
          msg = strcat(['Field ' num2str(ifield) ' done!']);
          disp(msg);
    end
end

if(Nfields==1)
  close all
  surf(lk);
  view(2);
  shading('interp');
  axis('equal','off');
  caxis([-3 3]);
end