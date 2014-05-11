function [ tMatrix ] = fiPar2Matrix( iPar )
%FIPAR2MATRIX Summary of this function goes here
%   Detailed explanation goes here

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
tMatrix(1,4)=tx;
tMatrix(2,4)=ty;
tMatrix(3,4)=tz;
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
