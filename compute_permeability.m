function kperm = compute_permeability(K,grid,par)
%Permeability field
%
  if (isempty(K.file))

    kfile = strcat('./K-sigma-',num2str(K.var_lnk),'.mat');
    K.file = kfile;
    
  end
%
  if  (~K.isHet)
  
    kperm = ones(grid.Nz,grid.Nx);

  else
      
    if (K.load)
      %saved fields always have zero mean and variance 1
      K2 = load(K.file);
      kperm = K2.kperm;
  
    else
      % log(kperm) has zero mean and variance 1.
      [kperm, var_lnk_actual] = calc_perm(grid, K);

    end
    
    
    
    %rescaling.
    lk = log(kperm);
    lk = zscore(lk);
    K.kperm = kperm;
    %The field is always saved before rescaling.
    save(K.file,'kperm','K','grid');

    std_lnk = sqrt(K.var_lnk);
    kperm = exp(std_lnk*lk);
    K.kperm = kperm;
  
  end
%
end