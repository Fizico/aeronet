function []=aeronet_plot_ONEILL_box(jd, aot, ylab, mdry, mwet, ylog, tit)

if ~exist('ylog','var') ylog=0; end

% large horizontal plot
set(gcf,'position',[400 400 1200 500]); % units in pixels!
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3])
%-----------------------------------------------------------------------
% climatology on the left side
%-----------------------------------------------------------------------
sub1=subplot('position',[0.08 0.05 0.73 0.85]); %left
XX(1:size(aot,1),1:12)=NaN;
for i=1:size(aot,1)
  data=datevec(jd(i));
  XX(i,data(2))=aot(i,1);
end
bp = boxplot(XX,'whisker',1000);
set(bp,'lineWidth',2)
% set vertical scale
%maxval=max(aot)*1.2;
%minval=0;
yval=get(gca,'ylim'); minval=yval(1); maxval=yval(2);
if (ylog)
  if (minval<0)
    minval=min(aot(:,1));
  end
  maxval=10^(ceil(log10(maxval)));
  minval=10^(floor(log10(minval)));
  ylim([minval maxval]); 
  set(gca,'yscale','log');
else
  ylim([minval maxval]); 
end
xlim([month(jd(1))-1 month(jd(end))+1]);
ylabel(ylab,'fontsize',12);
xlabel('Months','fontsize',12);
grid on;
title(tit);
%-----------------------------------------------------------------------
% histograms on right side
%-----------------------------------------------------------------------
sub2=subplot('position',[0.85 0.05 0.12 0.85]); %right
linkaxes([sub1 sub2],'y');
if (ylog)
  bins=10.^[log10(minval):(log10(maxval)-log10(minval))/100:log10(maxval)];
else
  bins=[minval:(maxval-minval)/100:maxval];
end
hdry=histc(reshape(XX(:,mdry),[],1),bins);
stairs(hdry/sum(hdry),bins,'r','linewidth',2); 
hold(gca,'on');
hwet=histc(reshape(XX(:,mwet),[],1),bins);
stairs(hwet/sum(hwet),bins,'b','linewidth',2); 
% set vertical scale
if (ylog)
  maxval=10^(ceil(log10(maxval)));
  minval=10^(floor(log10(minval)));
  ylim([minval maxval]); 
  set(gca,'yscale','log');
else
  ylim([minval maxval]); 
end
xlabel('freq','fontsize',12);
% set horizontal scale
tmp=get(sub2,'xtick');
xtic=linspace(0, max([hdry/sum(hdry);hwet/sum(hwet)])*1.2, 4);
xlim([min(xtic) max(xtic)]);
% xticl=' ';
% for i=2:numel(xtic)
%   tmp=sprintf('%4.2f',xtic(i));
%   xticl=[xticl '|' tmp(2:4)];
% end
% set(gca,'XTick',xtic);
% set(gca,'xticklabel',xticl);
set(sub2,'yticklabel','');
xlabel(sub2, 'Frequency');
set([sub1 sub2], 'FontSize',14);
grid on; 
pos1 = get(sub1,'Position');
pos2 = get(sub2,'Position');
set(sub2,'position', [pos2(1) pos1(2) pos2(3) pos1(4)]);
%-----------------------------------------------------------------------
% basis stats in a textbox
%-----------------------------------------------------------------------
medi(1)=nanmean(reshape(XX,[],1));
medi(2)=nanmean(reshape(XX(:,mdry),[],1));
medi(3)=nanmean(reshape(XX(:,mwet),[],1));
desv(1)=nanstd(reshape(XX,[],1));
desv(2)=nanstd(reshape(XX(:,mdry),[],1));
desv(3)=nanstd(reshape(XX(:,mwet),[],1));
% text goes inside the box
stats=['Mean\pmstd:' char(10) 'all: ' sprintf('%4.2f',medi(1)) '\pm' ...
       sprintf('%4.2f',desv(1)) char(10) ...
       'dry: ' sprintf('%4.2f',medi(2)) '\pm' ...
       sprintf('%4.2f',desv(2)) char (10) ...
       'wet: ' sprintf('%4.2f',medi(3)) '\pm' ...
       sprintf('%4.2f',desv(3)) ];
% average the first month with values to know where to place the box
first_empty_months = find(~sum(~isnan(XX),1)==0, 1);
tmp=nanmean(reshape(XX(:,first_empty_months),[],1));
bxw=0.10;
byw=0.10;
bx=pos1(1)+pos1(3)*0.035;
if (abs(maxval-tmp) > abs(tmp-minval))
  % top
  by=pos1(2)+pos1(4)-byw-pos1(4)*0.02;
else
  % bottom
  by=pos1(2)+pos1(4)*0.02;
end
%annotation('textbox', [pos(1), pos(2)+pos(4)-0.20, 0.15, 0.199], ...
annotation('textbox', [bx, by, bxw, byw], ...
           'string', stats,...
           'backgroundcolor','w',...
           'HorizontalAlignment','center',...
           'FontSize',14);
%