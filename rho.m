function [r] = rho(par,conc)  

 
  switch (par.denslaw)
    
    case (0) %constant density
      
      r = zeros(size(conc));
      %ratio = 0;
      
    case (1) %PG+water
      
      c2 = conc.^2;
      c3 = conc.*c2;
      r = (6.18725*c3 -17.8607*c2 + 8.071574*conc);
      %ratio = 1.0247/0.0086;
      
    case 2 %linear

      r = -3.6*conc;
      %ratio = 1;

    case -2 %linear -1

      r = -1.0*conc;
    
    case 3 %canonical rho = c

      r = conc;
    case 7 %tobias
      
       r =-23.333*conc.*conc + 10*conc;
      
  end %switch
  
  
end
