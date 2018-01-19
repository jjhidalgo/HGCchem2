function [t, saveopt] = time_update(t,grid,par,por,saveopt,umax)

  t.dt = min([time_update_dt(grid,par,por,umax) t.dt_custom]);


  t.iframe = t.iframe + saveopt.now(); %if just saved increases counter
  t.ipost = t.ipost + saveopt.post();  % idem
  
  t_write = t.iframe*t.Tpar;          %time when data will be saved.
  t_postprocess = t.ipost*t.Tpar/t.npost;  %time when other magnitudes will be saved
  delta_time = t_write - t.timesc;
  delta_post = t_postprocess - t.timesc;
  saveopt.now = false();
  saveopt.post = false();
  
  if (delta_post<=t.dt)
    t.dt = delta_post;
    t.timesc = t_postprocess;
    saveopt.post = true();
    if (delta_time<=t.dt)
      t.timesc = t_write;
      saveopt.now = true();
    end
  else
    t.timesc = t.timesc + t.dt;
    % we could save the state here to restart unfinished simulations
  end

  if (t.dt<1e-10 && ~saveopt.now) %dt can be small because 
                                  %we want to save the data 
                                  %at an exact time.
    disp('Time step very small!');
    disp(t.dt);
    error('Small time step');
  else
      disp(t.dt);
  end

  %restart file

  if saveopt.now

    saveopt.restart = (mod(t.iframe,5)==0);

  else

    saveopt.restart=false();

  end
end
