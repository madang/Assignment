function [ oX,oY,oZ ] = rigidTrans( ct, iPar)
%RIGIDTRANS Summary of this function goes here

tMatrix=fiPar2Matrix(iPar);
%% find center of ct block in world coordinates
% QUICK AND DIRTY again - using the fact that along all dimensions the
% number of elements is odd
ct.center_x=(ct.gridX(ceil((numel(ct.gridX)+1)/2))+ct.gridX(floor((numel(ct.gridX)+1)/2)))/2;
ct.center_y=(ct.gridY(ceil((numel(ct.gridY)+1)/2))+ct.gridY(floor((numel(ct.gridY)+1)/2)))/2;
ct.center_z=(ct.gridZ(ceil((numel(ct.gridZ)+1)/2))+ct.gridZ(floor((numel(ct.gridZ)+1)/2)))/2;

%% Shift grids to the center
ct.gridX=ct.gridX-ct.center_x;
ct.gridY=ct.gridY-ct.center_y;
ct.gridZ=ct.gridZ-ct.center_z;

%% Apply pure rotation
[ct.gridX,ct.gridY,ct.gridZ]=f_transform_my_grid(ct,tMatrix);

%% Shift the grids back

ct.gridX=ct.gridX+ct.center_x;
ct.gridY=ct.gridY+ct.center_y;
ct.gridZ=ct.gridZ+ct.center_z;

%% Return values
oX=ct.gridX;
oY=ct.gridY;
oZ=ct.gridZ;
end

