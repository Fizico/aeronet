clear all
list=dir('merge_*');
j=0;
for i=1:numel(list)
  if list(i).isdir
    j=j+1;
    ldir(j)=list(i);
  end
end
ldir.name

for i=1:numel(ldir)
  fname=[ldir(i).name '/' ldir(i).name '.ONEILL_20'];
  disp(['reading: ' fname]);
  clear aero;
  aero=aeronet_read_ONEILL(fname)
  disp('ploting...');
  aeronet_plot_ONEILL;

  fname=[ldir(i).name '/' ldir(i).name '.lev20'];
  disp(['reading: ' fname]);
  clear aero;
  aero=aeronet_read_lev(fname)
  disp('ploting...');
  aeronet_plot_lev;
end
%