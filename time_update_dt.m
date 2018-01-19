function dt = time_update_dt(grid,par,por,umax)

  pmin = max(max(por.por));
  
  dt_diff = 0.15*par.Ra*(min(grid.dx,grid.dz)^2);    % Diffusive time step (constant)
  
  if (par.displ>0 || par.dispt>0)
    dt_disp = (0.01/(par.displ*par.dispt))*(min(grid.dx,grid.dz)^2);
  else
    dt_disp = 1e6;
  end
  
  if (umax>1e-12)
    dt_adv = 0.5*min(grid.dx,grid.dz)*(pmin/umax); 
  else
    dt_adv = 1e6;
  end

  if (par.Pe>0)
    dt_inj = 0.15*par.Pe*(min(grid.dx,grid.dz)^2);   % Injection time step (constant)
  else                                   % if G =0 (no injection) => Pe = 0.
    dt_inj = 1e6;
  end

  if par.isReact && par.reactlaw>0
    delta_u = abs(par.u1-par.u2);
    d2 = (min(grid.dx,grid.dz)^2);
    dt_por = 1e-3*(delta_u/d2)*(par.Np/par.Ra);
  else
    dt_por = 1e6;
  end
    dt = min([dt_adv dt_diff dt_disp dt_inj dt_por]);
  
end
  