function [ tMatrix ] = IntristicRotationAndTranslationMatrix( iPar, iCenter)
%   Detailed explanation goes here
%% Create center shift matrices

tCenterShiftMatix=[1 0 0 -iCenter(1);0 1 0 -iCenter(2);0 0 1 -iCenter(3); 0 0 0 1];
tInvCenterShiftMatrix=[1 0 0 iCenter(1);0 1 0 iCenter(2);0 0 1 iCenter(3); 0 0 0 1];

%% Create pure rotation matrix
tMatrix =fPureRotMatrix(iPar);


%% Create pure translation matrix


TranslationMatrix=[1 0 0 iPar(1);0 1 0 iPar(2);0 0 1 iPar(3); 0 0 0 1];
%% First shift to center, then rotate, then shift back to original origin, then translate
tMatrix=TranslationMatrix*tInvCenterShiftMatrix*tMatrix*tCenterShiftMatix;

end

