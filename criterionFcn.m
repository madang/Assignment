function oSM = criterionFcn( iPar, iType, ct, Xray )
% A criterion function to use in an optimizer, yields a similarity measure
%% TODO: Nothing - just be cariful since this is a good place for a nasty bug
% Will yeild unexpected results when iStep outside is changed
iStep=1;
pMasked=1;
% End bugplace
switch iType
    case 'cc'
        [oImage,oMask]=drr( ct, Xray, iStep, iPar);
        tcc=corrcoef(oImage(oMask),Xray.image(oMask));
        oSM=tcc(2);
    case 'mi'
        [oImage,oMask]=drr( ct, Xray, iStep, iPar);
        oSM=-MutualInformation(oImage(oMask),Xray.image(oMask));
    otherwise
        error(strcat('criterionFcn:: unknown iType:',iType));
end
%       oImage=drr( ct, Xray, iStep, iPar);
%       imshowpair(oImage,Xray.image);
%       ylabel(num2str(iPar));
%       xlabel(num2str(oSM));
%       drawnow expose;


end

