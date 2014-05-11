function [ogX, ogY, ogZ]=f_transform_my_grid(gx,gy,gz,iTransformMatrix)
% If you're an iXray then I will transform YOUR grid (:
A=iTransformMatrix*[gx(:)';gy(:)';gz(:)';ones(1,numel(gy))]; %Not optimizing yet

ogX=zeros(size(gx));
ogY=ogX;
ogZ=ogX;
ogX(:)=A(1,:);
ogY(:)=A(2,:);
ogZ(:)=A(3,:);

end