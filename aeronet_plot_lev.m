
hfig = figure(1); 

% exclude lines where any angstrom is negative
mask=~any(aero.angstrom'<0)';
% exclude lines where water vapor > 6cm
mask=mask&(aero.water(:,1)<6);

% ---- angstrom
clf;
aeronet_plot_ONEILL_points(aero.jd(mask), aero.angstrom(mask,3), 'AE_{\alpha})(440-675nm)', 'Extinction-related Angstrom exponent (AE_{\alpha}) between 440 and 675 nm')
out=[aero.file '_angstrom_points'];
savefig(hfig, [out '.fig']);
print([out '.png'],'-dpng'); 
% eval(['!mogrify -trim ' [out '.png']]); %trim image edges using ImageMagick

clf;
aeronet_plot_ONEILL_box(aero.jd(mask), aero.angstrom(mask,3), 'AE_{\alpha})(440-675nm)', 7:11, [1:6,12], 0, sprintf('AE_{\\alpha}(440-675nm) Wishker box: %s-%s', datestr(aero.jd(1),'mmm/yy'), datestr(aero.jd(end),'mmm/yy')));
out=[aero.file '_angstrom_box.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

% ---- water
clf;
aeronet_plot_ONEILL_points(aero.jd(mask), aero.water(mask,1), 'Water (cm)')
out=[aero.file '_water_points.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

clf;
aeronet_plot_ONEILL_box(aero.jd(mask), aero.water(mask,1), 'Water (cm)',...
                        7:11, [1:6,12] )
out=[aero.file '_water_box.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);
%



