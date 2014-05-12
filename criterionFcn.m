function oSM = criterionFcn( iPar, iType, ct, Xray )
% A criterion function to use in an optimizer, yields a similarity measure
%% TODO: Nothing - just be cariful since this is a good place for a nasty bug
% Will yeild unexpected results when iStep outside is changed
iStep=1;
% End bugplace
switch iType
    case cc
        tcc=corrcoeff(drr( ct, Xray, iStep, iPar),Xray.image);
        oSM=tcc(2);
    case mi
        oSM=MutualInformation(drr( ct, Xray, iStep, iPar),Xray.image);
    otherwise
        error(strcat('criterionFcn:: unknown iType:',iType));
end
      


end

