function [ oX,oY,oZ ] = rigidTrans( ct, iPar)
%RIGIDTRANS Summary of this function goes here

% ********QUICK AND DIRTY ******************
tx=iPar(1);
ty=iPar(2);
tz=iPar(3);
a=iPar(4); % rotation around 0z
b=iPar(5); % rotation around 0y
c=iPar(6); % rotation around 0x

rz=f_rot_helper(a,[3 3])'; % using transposition to save some coding
ry=f_rot_helper(b,[3 2]); 
rx=f_rot_helper(c,[3 1]);

%% construct a pure rotation matrix
tMatrix=eye(4);
tMatrix(1:3,1:3)=rx*ry*rz; %for column vectors 

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

function omat=f_rot_helper(angle,swap)
%swap is what columns to swap
    r=[cosd(angle) sind(angle) 0;
    -sind(angle) cosd(angle) 0;
    0   0   1];
m=swap(1);
n=swap(2);
    r([m n],:)=r([n m],:);
    r(:,[m n])=r(:,[n m]);
omat=r;
end