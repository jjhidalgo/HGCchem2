function [res_out] = postprocess(c,t,grid,par,res_in)
%
% Edit this function to include the computation of
% magnituded that have to be save more of than than concentration.
%
% Save each magnitude as a field in res_out structure.
% Use fuction save_postprocess to save data.
% 
  if t.ipost>0
    res_out = res_in;
  end
  
  v = [0.1 0.2 0.3 0.4 0.5 0.5609 0.6 0.7 0.8 0.9];
  res_out.nose(t.ipost+1) = hgc_nose(grid,c,v);
  res_out.time(t.ipost+1) = t.timesc;
  res_out.mass(t.ipost+1) = hgc_mass(grid,c);
  %
  cont = struct2cell(hgc_contour(grid,c,v));
  res_out.cont(t.ipost+1) = {cont};
  %
end