function rr = react_rate(par,c)

  rr = zeros(size(c));
  u = c*par.u1+(1-c)*par.u2;
  
  switch(par.reactlaw)
    
    case(1) %Calcite cubic law
     
      f =zeros(size(u));
     dfu =zeros(size(u));
     dfduu = zeros(size(u));
     
     f = sqrt(27*u.*u+4)/(2*sqrt(27)) + u/2;
     dfdu = (sqrt(27)*u)./(2*sqrt(27*u.*u+4)) + 0.5;
     dfduu = sqrt(27)./(2*sqrt(27*u.*u+4)) ...
        - (27*sqrt(27)*u.*u)./(2*realpow((27*u.*u+4),3/2));
   
     rr = (1./(3*realpow(f,2/3)) + 1./(9*realpow(f,4/3))).*dfduu ...
     -(2./(9*realpow(f,5/3)) + 4./(27*realpow(f,7/3))).*dfdu.*dfdu;

  end%switch reactlaw
  
  rr = rr*(par.u1-par.u2)*(par.u1-par.u2);
end