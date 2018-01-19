function save_postprocess(c,t,grid,par,post_res)
%
% Saves derived custom maginuted computed in postprocess.m
% and stored in res.
%
% Build vectors or matrices or structures with the data
% contained in post_res. Then, save them.
%
%
  Ra = par.Ra;
  R = par.R;
 %
  nose = post_res.nose;
  mass = post_res.mass;
  
  % Contours are stored as a cell. They have to be converted to
  % a format compatible with hgc_toolbox
  % I don't understad why but the following works.
  nct = size(post_res.cont,2);
  cont = cell(1,nct);
  %cont=[];
  for ic = 1:nct
    ct = {post_res.cont(ic)};
    ct = cell2struct(ct{1}{1},{'Level';'Length';'X';'Y';'arc_length'},1);
    cont(1,ic) = {ct};
  end
  
  time = extractfield(post_res,'time');
 
  root = hgc_filename_root(Ra,R);
  nose_file = strcat(['nose-' root '.mat']);
  mass_file = strcat(['mass-' root '.mat']);
  cont_file = strcat(['cont-' root '.mat']);
 
 
  save(nose_file,'nose','Ra','R','time');
  save(mass_file,'mass','Ra','R','time');
  save(cont_file,'cont','Ra','R','time');
 
end