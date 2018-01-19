function [drho, ratio] = drhodc(par,conc)  

 
  switch (par.denslaw)
    
    case (0) %constant density
      
      drho = zeros(size(conc));
      ratio = 1.;
      
    case (1) %PG+water
      
      c2 = conc.^2;
      drho = (3.*6.18725*conc.*conc -2.*17.8607*conc + 8.071574);
      ratio = 1.0247/0.0086;
      
    case 2 %linear

      drho = -3.6;
      ratio = 1;

    case -2 %linear -1

      drho = -1.0;
      ratio = 1000/1025;
      
    case 3 %canonical rho = c

      drho = 1.0;
      ratio = 1000/(1025-1000);
    case 7 %tobias
      
       drho =-2.*23.333*conc + 10;
       ratio = 1;
  end %switch
  

end
