function kperm = compute_permeability(K,grid,par)
%Permeability field
%

  kfile = strcat('./K-Pe',num2str(par.Pe),'-R',num2str(par.R),'.mat');

  if (isempty(K.file))
    
    K.file = kfile;
    
  end
%
  if (K.load)
  
    kperm=struct2array(load(K.file));
  
  elseif (K.isHet && ~K.load)
  
    [kperm var_lnk_actual] = calc_perm(grid,K);
    lk = log(kperm);
    lk = zscore(lk);
    kperm = exp(lk);
  
    save(kfile,'kperm','K','grid');
  
  elseif (~K.isHet)
  
    kperm = ones(grid.Nz,grid.Nx);
  
  end
%
end