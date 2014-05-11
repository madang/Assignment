function [ oX,oY,oZ ] = rigidTrans( ct, iPar)
%RIGIDTRANS Summary of this function goes here



%% find center of ct block in world coordinates
% if number of elements is odd then ceil= floor else we have a mean
cx=(ct.gx(ceil((numel(ct.gx)+1)/2))+ct.gx(floor((numel(ct.gx)+1)/2)))/2;
cy=(ct.gy(ceil((numel(ct.gy)+1)/2))+ct.gy(floor((numel(ct.gy)+1)/2)))/2;
cz=(ct.gz(ceil((numel(ct.gz)+1)/2))+ct.gz(floor((numel(ct.gz)+1)/2)))/2;


tMatrix = IntristicRotationAndTranslationMatrix( iPar, [cx;cy;cz]);

%% Apply pure rotation
[oX,oY,oZ]=f_transform_my_grid(ct.gx,ct.gy,ct.gz,tMatrix);


end



