function c = transport(par,por,t,c,ux,uz,Az,Azz,Bz,Bzz,Ax,Axx,Bx,Bxx);

  for istage = 1:3;
        
    [F] = f_trans(par,por,c,ux,uz,Az,Azz,Bz,Bzz,Ax,Axx,Bx,Bxx);
        
    if istage==1;
        c = c + t.dt*( (8/15)*F );
        F1 = F;

    elseif istage==2;
        c = c + t.dt*( (5/12)*F + (-17/60)*F1 );
        F1 = F;
    else
        c = c + t.dt*( (3/4)*F + (-5/12)*F1 );
    end
%
% Boundary conditions
%
% Left and right boundaries
%
% If flow has a Dirichlet b.c. and concentration is not prescribed
% a mass flow condition is used for transport.
%
% If q.n > 0 the we use the outside concentration
% If q.n < 0 we use the resident.
%
    if par.LeftIsDirichletTpt
        c(:,1) = par.cL;
    else
        
      if par.LeftIsDirichletFlow
        c(ux(:,1)>0,1) = par.cL;
        c(ux(:,1)<=0,1) = c(ux(:,1)<=0,2);
      else
        c(:,1) = c(:,2);
      end
    end

    if par.RightIsDirichletTpt
        c(:,end) = par.cR;
    else

      if par.RightIsDirichletFlow
        c(ux(:,end)<0,end) = par.cR;
        c(ux(:,end)>=0,end) = c(ux(:,end)>=0,end-1);
      else
        c(:,end) = c(:,end-1);
      end
    end
%
% Top and bottom boundaries
%  
    if ~par.IsPeriodic
      c(1,:) = c(2,:);
      c(end,:) = c(end-1,:);
    end

  end %for      
  
end