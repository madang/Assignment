function [ oct,oTe,oVe,oXray ] = Driver2( ct, Te, Ve, Xray )
%DRIVER2 Summary of this function goes here
%   Detailed explanation goes here

%% Create sampling grids of the 2D X-ray and 3D CT images by using the Matlab function ndgrid()
[Xray.gridX,Xray.gridY,Xray.gridZ]=ndgrid(1:size(Xray.image,2),1:size(Xray.image,1),1);% because sampling is isotropic with step 1(mm)
[ct.gridX,ct.gridY,ct.gridZ]=ndgrid(1:size(ct.volume,1),1:size(ct.volume,2),1:size(ct.volume,3));% because sampling is isotropic with step 1(mm)

%% Transform the sampling grids into the reference coordinate system
%*************QUICK AND DIRTY*******************


% A=Xray.TPos*[Xray.gridX(:)';Xray.gridY(:)';Xray.gridZ(:)';ones(1,numel(Xray.gridY))]; %Not optimizing yet
% Xray.gridX(:)=A(1,:);
% Xray.gridY(:)=A(2,:);
% Xray.gridZ(:)=A(3,:);

[Xray.gx,Xray.gy,Xray.gz]=f_transform_my_grid(Xray,Xray.TPos);
Xray.currentTransform=Xray.TPos;
[ct.gx,ct.gy,ct.gz]=f_transform_my_grid(ct,ct.TPos);
ct.currentTransform=ct.TPos;

%% Show the transformed 3D and 2D sampling grids and the position of the X-ray source Xray.SPos by using the function plot3().
% blue for Xray

ts=150;% spacing to speed up plots interaction
plot3(Xray.gx(1:ts:end),Xray.gy(1:ts:end),Xray.gz(1:ts:end),'.','Color','b');
grid on;
hold on;
% Green for ct

plot3(ct.gx(1:ts:end),ct.gy(1:ts:end),ct.gz(1:ts:end),'.','Color','g');

% Magenta for the source
plot3(Xray.SPos(1),Xray.SPos(2),Xray.SPos(3),'.','Color','m')

%% Let's spit out all the data necessary for the next questions
 oct=ct;
 oTe=Te;
 oVe=Ve;
 oXray=Xray;
end

