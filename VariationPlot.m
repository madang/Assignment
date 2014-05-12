function  VariationPlot( ct,Xray,iRange, iParpos)
%VARIATIONPLOT Summary of this function goes here
%   Detailed explanation goes here
iPar=[0 0 0 0 0 0];
iStep=1;
for i=1:numel(iRange) 
    iPar(iParpos)=iRange(i);
    [oImage, ~] = drr( ct, Xray, iStep, iPar);
    %% SHOULD I ONLY COMPUTE IN THE MASK?
    ccm=corrcoef(oImage,Xray.image);
    cc(i)=ccm(2);
end
figure;plot(iRange,cc);

end

