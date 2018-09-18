function [Am,T]= p_matrix(grid,par,K,conc)
%
% Computes flow system matrix.
%
% Assumes dz=dx=h.
%
  Nz = grid.Nz;
  Nx = grid.Nx;
  %h = grid.h;
  dx = grid.dx;
  dz = grid.dz;
  dx2 = dx*dx;
  dz2 = dz*dz;
%  
  Np = Nz*Nx;    
  mu = ones(size(K.kperm));  
  
  if (abs(par.R)>0)

    mu = (exp(par.R*(par.cmax-conc)))./K.kperm;
    
  elseif(K.isHet)
    
    mu = 1./K.kperm;

  end
%
% Transmisibility matrices.
%
  T.Tx = zeros(Nz,Nx+1);
  T.Tx(:,2:Nx) = (2*dz)./(mu(:,1:Nx-1) + mu(:,2:Nx));
%
  T.Ty = zeros(Nz+1,Nx);
  T.Ty(2:Nz,:) = (2*dx)./(mu(1:Nz-1,:) + mu(2:Nz,:));
%
  T.Tx1 = reshape(T.Tx(:,1:Nx),Np,1);
  T.Tx2 = reshape(T.Tx(:,2:Nx+1),Np,1);
%
  T.Ty1 = reshape(T.Ty(1:Nz,:),Np,1);
  T.Ty2 = reshape(T.Ty(2:Nz+1,:),Np,1);
% 
  Ty11 = T.Ty1;
  Ty22 = T.Ty2;
%
  if par.IsPeriodic
      
    T.Typ = (2*dx)./(mu(Nz,:)+mu(1,:));
  
    T.TypUp = zeros(Np,1);
    T.TypDw = zeros(Np,1);
  
    ixup = 1:Nz:Np-Nz+1;
    ixup = ixup + Nz-1;
    ixdw = 1:Nz:Np-Nz+1;
    
    T.TypUp(ixup,1) = T.Typ(:);
    T.TypDw(ixdw,1) = T.Typ(:);
  end
%
% Assemble system of equations
%
  Dp = zeros(Np,1);
  Dp = T.Tx1/dx2 + T.Ty1/dz2 + T.Tx2/dx2 + T.Ty2/dz2;

  if par.RightIsDirichletFlow
 
      T.TxDirichR = (2*dz).*(1./mu(:,Nx));

      Dp(Np-Nz+1:Np,1) = T.Ty1(Np-Nz+1:Np,1)/dz2 + ...
                         T.Tx1(Np-Nz+1:Np,1)/dz2 + ...
                         T.Ty2(Np-Nz+1:Np,1)/dx2 + ...
                         T.TxDirichR/dx2;
  end
%
  if par.LeftIsDirichletFlow
 
      T.TxDirichL = (2*dz).*(1./mu(:,1));

      Dp(1:Nz,1) = T.Ty1(1:Nz,1)/dz2 + ...
                   T.Tx2(1:Nz,1)/dz2 + ...
                   T.Ty2(1:Nz,1)/dx2 + ...
                   T.TxDirichL/dx2;
  end
%

  if par.IsPeriodic
    Dp(1:Nz:Np,1) = Dp(1:Nz:Np,1) + T.Typ(:)/dz2;
    Dp(Nz:Nz:Np,1) = Dp(Nz:Nz:Np,1) + T.Typ(:)/dz2;
%
    Am = spdiags(...
     [-T.Tx2/dx2, ...
      -T.TypDw/dz2,...
      -Ty22/dz2,  Dp, -Ty11/dz2,  ...
      -T.TypUp/dz2, ...
      -T.Tx1/dx2], ...
   [-Nz,-Nz+1, -1, 0, 1,Nz-1, Nz], Np, Np);

  else

    Am = spdiags(...
     [-T.Tx2/dx2, ...
      -Ty22/dz2,  Dp, -Ty11/dz2,  ...
      -T.Tx1/dx2], ...
   [  -Nz, -1, 0, 1, Nz], Np, Np);
  end
% 
end
