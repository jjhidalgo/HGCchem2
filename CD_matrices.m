function [Az,Bz,Azz,Bzz]= CD_matrices(Nz,dz,isPeriodic)
%
% Computed the matrices for first and second derivatives.
% Compact schemes.
%
%
% First derivative (Z direction)
% Differentiation matrices of the compact scheme 6th order
%
  alfa = 1/3;
  a = 14/9;
  b = 1/9;
% c = 0
%
%
%
  R = [1 alfa zeros(1,Nz-2)];
  Az = toeplitz(R,R);
%
  C = [0 a/2 b/4  zeros(1,Nz-5) -b/4 -a/2]/dz;
  Bz = toeplitz(-C,C);
%
% Boundaries
%
  if isPeriodic
    Az(1,end) = alfa;
    Az(Nz,1) = alfa;
  else

    Az(1,:) = [1 2 zeros(1,Nz-2)];
    Az(2,:)= [1/4 1 1/4 zeros(1,Nz-3)]; 
    Az(Nz-1,:)= [zeros(1,Nz-3) 1/4 1 1/4];
    Az(Nz,:) = [zeros(1,Nz-2) 2 1];
%
    Bz(1,:)= [-5/2 2 1/2 zeros(1,Nz-3)]/dz;
    Bz(2,:)= [-3/4 0 3/4 zeros(1,Nz-3)]/dz;
    Bz(Nz-1,:)= [zeros(1,Nz-3) -3/4 0 3/4]/dz;
    Bz(Nz,:)= [zeros(1,Nz-3) -1/2 -2 5/2]/dz;
  end
  Az = sparse(Az);
  Bz = sparse(Bz);
%
% Second derivative
%
  alfa = 2/11;
% beta =0;
  a = 12/11;
  b = 3/11;
% c = 0;
%
  ddz = dz*dz;
%
%
  R = [1 alfa zeros(1,Nz-2)];
  Azz = toeplitz(R,R);
  C = [-2*(a+b/4) a b/4  zeros(1,Nz-5) b/4 a]/ddz;
  Bzz = toeplitz(C,C);
%
% Boundaries
  if isPeriodic
    Azz(1,end) = alfa;
    Azz(Nz,1) = alfa;
  else
    Azz(1,:) = [1 11 zeros(1,Nz-2)];
    Azz(2,:) = [1/10 1 1/10 zeros(1,Nz-3)];
    Azz(Nz-1,:) = [zeros(1,Nz-3) 1/10 1 1/10];
    Azz(Nz,:) = [zeros(1,Nz-2) 11 1];
%
    Bzz(1,:) = [13 -27 15 -1 zeros(1,Nz-4)]/ddz;
    Bzz(2,:) = [6/5 -12/5 6/5 zeros(1,Nz-3)]/ddz;
    Bzz(Nz-1,:) = [zeros(1,Nz-3) 6/5 -12/5 6/5]/ddz;
    Bzz(Nz,:) = [zeros(1,Nz-4) -1 15 -27  13]/ddz;
  end

  Azz = sparse(Azz);
  Bzz = sparse(Bzz);
%  Dzz= Azz\Bzz;
end