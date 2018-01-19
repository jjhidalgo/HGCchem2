function por_out = porosity(par,por,c,t,Ax,Bx,Az,Bz,ux,uz)
%
% Gradient of c
%
  dcx = (Ax\(Bx*c'))';
  dcz = Az\(Bz*c);
%
% reaction rate
%
  
  rr = react_rate(par,c);
  
  displ = par.displ;
  dispt = par.dispt;
  
  dxx = 0.;
  dzz = 0.;
  dxz = 0.;
  
  if (displ>0 || dispt>0)
      
    modu = sqrt(ux.*ux+uz.*uz);
%
    dxx =  dispt*modu + (displ-dispt)*(ux.*ux)./modu;
    dzz =  dispt*modu + (displ-dispt)*(uz.*uz)./modu;
    dxz = (displ-dispt)*(ux.*uz)./modu;

    dxx = dxx./por.por;
    dzz = dzz./por.por;
    dxz = dxz./por.por;
    
  end  
  
  Dgradc2 = (dxx + 1./par.Ra).*dcx.*dcx + ...
            (dzz + 1./par.Ra).*dcz.*dcz + ...
            2.*dxz.*dcx.*dcz;
  
  por_out = por.por.* exp(-t.dt.*rr.*par.Np.*Dgradc2);
%
% The maximum porosity allowed is  (1/por.ini)
%
  ix = por_out>1./por.ini;
  por_out(ix) = 1.0./por.ini(ix);

  %ix = por_out>1./por.char;
  %por_out(ix) = 1.0./por.char;

  por_out(por_out<1e-10) = 1e-10;
  
end