function cmax = cmax_visc(denslaw)
  
switch (denslaw)
    
    case (0) %constant density
      
      cmax = 1;
      
    case (1) %PG+water
      
      cmax = 0.26149;
      
    case 2 %linear

      cmax = 0;

    case -2 %linear -1

     cmax = 0;

    case 3 %canonical

     cmax = 1;

    case 7 %tobias
    
    cmax = 0.3;
  end %switch
  
