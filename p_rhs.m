function [ux_avg,uz_avg,p]= p_rhs(grid,par,conc,Am,T,t,pk,dcdt)

% Computes right hand side of flow system and solves.
%
%

  Nx = grid.Nx;
  Nz = grid.Nz;
  dx = grid.dx;
  dz = grid.dz;
  Np = grid.Nz*grid.Nx;
%
% Density
%
% If horizontal, only average in z direction is computed.
%
  if (abs(grid.angle)>1e-5)
    [rhoavg_z, rhoavg_x] = rho_average(grid,par,conc);
    rhoavg_x1 = reshape(rhoavg_x(:,1:Nx),Np,1); %rho j-1/2  (x direction)
    rhoavg_x2 = reshape(rhoavg_x(:,2:Nx+1),Np,1); %rho j+1/2
  else
    [rhoavg_z] = rho_average(grid,par,conc);
  end
%
  rhoavg_z1 = reshape(rhoavg_z(1:Nz,:),Np,1); %rho i-1/2  (z direction)
  rhoavg_z2 = reshape(rhoavg_z(2:Nz+1,:),Np,1); %rho i+1/2  

%
% Source term
%
%
  S = zeros(Np,1);
  pk = reshape(pk,Np,1);
%
if (par.isComp)
  
  S = S + (par.S*pk/t.dt)*dx;
  
  if abs(par.denslaw)>0
    [drdc,ratio] = drhodc(par,conc);
    S = S - reshape((drdc.*dcdt)./(rho(par,conc) + ratio),Np,1)*dx;
  end

  Am = Am + spdiags(par.S*dx*ones(Np,1)/t.dt,0,Np,Np);
  
end
%
% Bouyancy
%
  S = S + (rhoavg_z2.*T.Ty2 - rhoavg_z1.*T.Ty1)*grid.cos/dx;
%
  if (abs(grid.angle)>1e-5)   
    S = S + (rhoavg_x2.*T.Tx2 - rhoavg_x1.*T.Tx1)*grid.sin/dz; 
  end

% If any boundary condition is time dependent. Put the function here.
% Example: Velocity at left boundary.
%
%  w = 2*pi*2.7273e3/0.5;
%  par.uL = par.G*sin(w*t.timesc);
%  par.uL = 1;
%
% Boundary conditions
%
  if par.LeftIsDirichletFlow
    S(1:Nz,1) = S(1:Nz,1) + T.TxDirichL.*(par.pL/dx/dx);
  else
    S(1:Nz,1) = S(1:Nz,1) + par.uL/dx;
  end
  
  if par.RightIsDirichletFlow
      S(Np-Nz+1:Np,1) = S(Np-Nz+1:Np,1) + T.TxDirichR.*(par.pR/dx/dx);
  else
      S(Np-Nz+1:Np,1) = S(Np-Nz+1:Np,1) + par.uR/dx;
  end
  
  if ~par.RightIsDirichletFlow && ~par.LeftIsDirichletFlow && ~par.isComp
      S(1,1) = 0;
      Am(1,:) = 0;
      Am(1,1) = 1;
  end
%
% Solve system of equations
%
  p = Am\S;
  p = reshape(p,Nz,Nx);
  p = full(p);
%
% Compute velocities
%
  ux = zeros(Nz,Nx+1);
  uy = zeros(Nz+1,Nx);
%
%
  ux(:,2:Nx) = -T.Tx(:,2:Nx).*(p(:,2:Nx) - p(:,1:Nx-1))/dx;
  if (abs(grid.angle)>1e-5)
    ux(:,2:Nx) = ux(:,2:Nx) - T.Tx(:,2:Nx).*rhoavg_x(:,2:Nx)*grid.sin;
  end
  
  if par.LeftIsDirichletFlow
    ux(:,1) = -T.TxDirichL.*(p(:,1)-par.pL)/(dx/2);
    if (abs(grid.angle)>1e-5)
      ux(:,1) = ux(:,1) -T.TxDirichL.*rhoavg_x(:,1)*grid.sin;
    end
    
  else

    ux(:,1) = par.uL;
    
  end
  
  if par.RightIsDirichletFlow
    ux(:,Nx+1) = -T.TxDirichR.*(par.pR-p(:,Nx))/(dx/2);
    if (abs(grid.angle)>1e-5)
      ux(:,Nx+1) = ux(:,Nx+1) -T.TxDirichR.*rhoavg_x(:,Nx+1)*grid.sin;
    end

  else
      ux(:,Nx+1) = par.uR;
  end
  
%
  uy(2:Nz,:) =  -T.Ty(2:Nz,:).*([p(2:Nz,:)]-[p(1:Nz-1,:)])/dz ...
                -T.Ty(2:Nz,:).*rhoavg_z(2:Nz,:)*grid.cos;

% periodic boundary conditions.
  if par.IsPeriodic
   uy(1,:) =  -T.Typ.*([p(1,:)]-[p(Nz,:)])/dz ...
                -T.Typ.*rhoavg_z(1,:)*grid.cos;
   uy(Nz+1,:) =  uy(1,:);  
  end
%
% Average velocity in the cell.
%
  ux_avg = zeros(Nz,Nx);
  uz_avg = zeros(Nz,Nx);
  ux_avg = 0.5*( ux(:,1:Nx)+ux(:,2:Nx+1) )/dz;
  uz_avg = 0.5*( uy(1:Nz,:)+uy(2:Nz+1,:) )/dx;
%
end
