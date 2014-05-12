function  VariationPlotMI( ct,Xray,iRange, iParpos, iWhat)
%VARIATIONPLOT Summary of this function goes here
%   Detailed explanation goes here
if nargin<5
    iWhat = '';
end

iPar=[0 0 0 0 0 0];
iStep=1;
for i=1:numel(iRange) 
    iPar(iParpos)=iRange(i);
    [oImage, ~] = drr( ct, Xray, iStep, iPar);
    %% SHOULD I ONLY COMPUTE IN THE MASK?
    
   
    mi(i)=MutualInformation(oImage,Xray.image);
end
figure;plot(iRange,mi);
xlabel(iWhat);
ylabel('mi');
saveas(gcf,strcat('mi','_var_',iWhat),'eps');

end



