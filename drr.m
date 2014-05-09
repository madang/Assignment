function [ oImage, oMask ] = drr( ct, Xray, iStep)
%DRR perform a cone-beam projection of ct to Xray plane form Xray.SPos
%   Detailed explanation goes here
xs=Xray.SPos(1);
ys=Xray.SPos(2);
zs=Xray.SPos(3);
%% PLAN
%% Loop over intristic coords of Xray.image

% a temporary step variable to speed stuff up while debugging
ts = 50;
    x=Xray.gridX(1:ts:end);
    y=Xray.gridY(1:ts:end);
    z=Xray.gridZ(1:ts:end);
    
    
%% Build a line from source to current Xray point
    kx=x-xs;
    ky=y-ys;
    kz=z-zs;
    %normalize the k vector
    kl=sqrt(kx.^2+ky.^2+kz.^2);
    kx = kx./kl;
    ky = ky./kl;
    kz = kz./kl;
    % get line points
    t=(1:max(kl))'; %we're going to have a bunch of lines, those that are 
    % shorter  then max(kl) are going to be extended, and later trimmed
    % this way we can make use of matlab indexing to increase the speed
    lx=xs+t*kx; %along columns - index of point in the same line
    ly=ys+t*ky; % along rows - different lines
    lz=zs+t*kz; % these are direct products
%% Find intersections of line with CT. Select an interval inside the volume
    % SKIPPING THIS FOR NOW SINCE ITERPN PROVIDES FUNCTIONALITY FOR EXTERNAL
    % POINTS
%% Calculate the integral through interpolation
    interpolated_values =interpn(ct.gridX,ct.gridY,ct.gridZ,ct.volume,lx,ly,lz);
    drr_pixel_values=sum(interpolated_values); %summation along columns (dim1)
    % this is  a row vector , to get an image we need to reshape it.
    oImage=reshape(drr_pixel_values,size(XRay.image));
   
%% return oMask as well
    oMask=zeros(size(oImage));
    oMask(oImage~=0)=1;
%%


end

