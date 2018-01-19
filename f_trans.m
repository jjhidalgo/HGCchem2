function [F]= f_trans(par,por,c,ux,uz,Az,Azz,Bz,Bzz,Ax,Axx,Bx,Bxx)
%
% 
  Ra = par.Ra;
  displ = par.displ;
  dispt = par.dispt;
%
  dcx = zeros(size(c));
  dcxx = zeros(size(c));
  dcz = zeros(size(c));
  dczz = zeros(size(c));
%
% TRANSPORT EQUATION
  dcx = (Ax\(Bx*c'))';
  dcxx = (Axx\(Bxx*c'))';
  dcz = Az\(Bz*c);
  dczz = Azz\(Bzz*c);
%
  F = -(ux.*dcx + uz.*dcz)./por.por + (1/Ra)*( dcxx + dczz );
%
% Dispersion
%
% Dij = alpha_T*|q|*delta_ij + (alpha_T - alpha_L)*(q_i q_j)/|q|
%
  if (displ>0 || dispt>0)
  
    modu = sqrt(ux.*ux+uz.*uz);
%
    dxx = dispt*modu + (displ-dispt)*(ux.*ux)./modu;
    dzz = dispt*modu + (displ-dispt)*(uz.*uz)./modu;
    dxz = (displ-dispt)*(ux.*uz)./modu;

    dxx(modu<1e-19) = 0;
    dzz(modu<1e-19) = 0;
    dxz(modu<1e-19) = 0;
%
    dispx = dxx.*dcx + dxz.*dcz;
    dispz = dxz.*dcx + dzz.*dcz;
%
    dispxx = (Ax\(Bx*dispx'))';
    dispzz = Az\(Bz*dispz);
%
    F = F + (dispxx + dispzz)./por.por;
    
  end
%
  clear dcx dcxx dcz dczz dispx dispxx dispz dispzz
%
end