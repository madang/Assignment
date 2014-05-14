function beautify(varargin)
%BEAUTIFY Summary of this function goes here
%   Detailed explanation goes here
wid=8.6;
hei=6.4;
if nargin>0 
    for argind=1:numel(varargin)
    switch varargin{argind}
        case 's'
    hei=wid;
        case 2
    wid=wid/2;
    hei=hei/2;
    end
    end
end
    
set(gcf,'units','centimeters','pos',[5 5 wid hei]);
set(gca,'FontName','Times New Roman','FontSize',8);


end

