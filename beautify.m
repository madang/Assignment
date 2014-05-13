function beautify(varargin)
%BEAUTIFY Summary of this function goes here
%   Detailed explanation goes here
wid=8.6;
hei=6.4;
if nargin>0 && varargin{1}>1
    wid=wid/2;
    hei=hei/2;
end
    
set(gcf,'units','centimeters','pos',[5 5 wid hei]);
set(gca,'FontName','Times New Roman','FontSize',8);
saveas(gcf,'cc_var_tx','eps');

end

