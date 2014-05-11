function [ogX, ogY, ogZ]=f_transform_my_grid(iXray,iTransformMatrix)
% If you're an iXray then I will transform YOUR grid (:
A=iTransformMatrix*[iXray.gridX(:)';iXray.gridY(:)';iXray.gridZ(:)';ones(1,numel(iXray.gridY))]; %Not optimizing yet

ogX=zeros(size(iXray.gridX));
ogY=ogX;
ogZ=ogX;
ogX(:)=A(1,:);
ogY(:)=A(2,:);
ogZ(:)=A(3,:);

end