function oXray=f_transform_my_grid(iXray,iTransformMatrix)
% If you're an iXray then I will transform YOUR grid (:
A=iTransformMatrix*[iXray.gridX(:)';iXray.gridY(:)';iXray.gridZ(:)';ones(1,numel(iXray.gridY))]; %Not optimizing yet
iXray.gridX(:)=A(1,:);
iXray.gridY(:)=A(2,:);
iXray.gridZ(:)=A(3,:);
oXray=iXray;
end