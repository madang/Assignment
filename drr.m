function [ oImage, oMask ] = drr( ct, Xray, iStep, iPar, iThreshold, iAdj)
if nargin<4
    iPar=[0 0 0 0 0 0];
end

if nargin<5
    iThreshold=66;
end
%DRR perform a cone-beam projection of ct to Xray plane form Xray.SPos
%   Detailed explanation goes here
xs=Xray.SPos(1);
ys=Xray.SPos(2);
zs=Xray.SPos(3);

%% Find intersections of line with CT. Select an interval inside the volume
    % SKIPPING THIS FOR NOW SINCE ITERPN PROVIDES FUNCTIONALITY FOR EXTERNAL
    % POINTS
    cx= fCornersCoords(ct.gx);
    cy= fCornersCoords(ct.gy);
    cz= fCornersCoords(ct.gz);
    originalCenter=[mean(cx);mean(cy);mean(cz)];
%% Done:transform corners with iPar
    temp1.gx=cx;
    temp1.gy=cy;
    temp1.gz=cz;
    [cx,cy,cz]=rigidTrans(temp1,iPar);
%    hold on;
%    plot3(cx,cy,cz,'ro');
    dx=cx-xs;
    dy=cy-ys;
    dz=cz-zs;
    
%     plot3(cx,cy,cz,'go');
    
    cd=sqrt(dx.*dx+dy.*dy+dz.*dz); %corner distance (from source)
    
    dmin=min(cd);
    dmax=max(cd);
    
%% Get coordinates of projection of ct.volume corners onto XRay plane
% Yes this is a premature optimization and I will burn in hell for this but
% I'll do this while it's still fun
%
% Used a plane intersection tutorial from here:
% http://www2.math.umd.edu/~jmr/241/lines_planes.html

% Get points in the Xray plane
  P1=[Xray.gx(1,1),Xray.gy(1,1),Xray.gz(1,1)];
  P2=[Xray.gx(1,end),Xray.gy(1,end),Xray.gz(1,end)];
  P3=[Xray.gx(end,end),Xray.gy(end,end),Xray.gz(end,end)];
% Get a normal to the Cray plane
  normal = cross(P1-P2, P1-P3);
  
% Get plane equation with symbolic vars
syms x y z;
P = [x,y,z];
planefunction = dot(normal, P-P1);

% Get poins for lines
syms t; %parameter for line
points=[cx',cy',cz'];
src=repmat(Xray.SPos,8,1);
lines=src+t*(points-src);
IntersectionPoints=zeros(8,3);
for ind =1:8
    newfunction = subs(planefunction, P, lines(ind,:));
    t0(ind) = solve(newfunction);
    IntersectionPoints(ind,:) = subs(lines(ind,:), t, t0(ind));
%     ezplot3(lines(1,1),lines(1,2),lines(1,3),[0,t0]);
end

%get intersection points inintristic coordiantes of Xray.image

[ipx,ipy,ipz]=f_transform_my_grid(IntersectionPoints(:,1),...
    IntersectionPoints(:,2),IntersectionPoints(:,3),inv(Xray.TPos));

%% TODO: Write a checkup here to see is all corners fit int image
xrange=floor(min(ipx)):ceil(max(ipx));
yrange=floor(min(ipy)):ceil(max(ipy));
% build a range of points in Cray,image that are good
% current implementation also inludes some bg pixels

%% Build a line from source to current Xray point
    kx=Xray.gx(xrange,yrange)-xs;
    ky=Xray.gy(xrange,yrange)-ys;
    kz=Xray.gz(xrange,yrange)-zs;
    %normalize the k vector
    kx=kx(:)'; ky=ky(:)'; kz=kz(:)';
    kl=sqrt(kx.^2+ky.^2+kz.^2);
    kx = kx./kl;
    ky = ky./kl;
    kz = kz./kl;
    
%% get line points
    t=(dmin:iStep:dmax)'; %we're going to have a bunch of lines, those that are 
    % shorter  then max(kl) are going to be extended, and later trimmed
    % this way we can make use of matlab indexing to increase the speed
    lx=t*kx+xs; %along columns - index of point in the same line
    ly=t*ky+ys; % along rows - different lines
    lz=t*kz+zs; % these are direct products
    
    
%     hold on;
% plot3(lx(1:200:end),ly(1:200:end),lz(1:200:end),'mo');
%% Calculate the integral through interpolation

    %% Apply inverse to iPar transform to lx,ly,lz
    % inverse means inverse translation followed by inverse rotation around
    % center of ct.volume
    
    tMatrix=IntristicRotationAndTranslationMatrix(iPar,originalCenter);
    
    
    % center of ct volume
    
    
    [lx, ly, lz]=f_transform_my_grid(lx,ly,lz,inv(tMatrix*ct.currentTransform));    
    invalid=(lx<1|lx>size(ct.gridX,1)|ly<1|ly>size(ct.gridY,2)|lz<1|lz>size(ct.gridZ,3));
    lx(invalid)=0;
    ly(invalid)=0;
    lz(invalid)=0;
    valid=not(invalid);
    interpolated_values=zeros(size(lx));
    v=single(ct.volume);
    v(v<=iThreshold)=0;
    interpolated_values(valid)=interpn(ct.gridX,ct.gridY,ct.gridZ,v,lx(valid),ly(valid),lz(valid),'linear',0);
    %interpn doesn't work with uint8 so there's a need for
    %single(ct.volume)
    drr_pixel_values=sum(interpolated_values); %summation along columns (dim1)
    % this is  a row vector , to get an image we need to reshape it.
    oImage=zeros(size(Xray.image));
    oImage(xrange,yrange)=reshape(drr_pixel_values,[numel(xrange),numel(yrange)])/(0.1*iStep);
%     oImage=reshape(drr_pixel_values,size(Xray.image));
   
%% return oMask as well
    oMask=false(size(oImage));
    oMask(xrange,yrange)=reshape(sum(valid)>0,[numel(xrange),numel(yrange)]);
%%
if nargin>5 && iAdj
    I0=255;
voxSizeCm=0.1; %voxel size in cm, isotropicity assumed
godCoeff=0.0005; %after one try without it all value were zero. This means 
% I didn't guess the units of \mu correctly so God decided that this
% coefficient should be present in the formula
oImage=I0*exp(-oImage*voxSizeCm*godCoeff);

end

end

function oCoords= fCornersCoords(grid)
    oCoords(1)=grid(1,1,1);
    oCoords(2)=grid(1,1,end);
    oCoords(3)=grid(1,end,1);
    oCoords(4)=grid(1,end,end);
    oCoords(5)=grid(end,1,1);
    oCoords(6)=grid(end,1,end);
    oCoords(7)=grid(end,end,1);
    oCoords(8)=grid(end,end,end);
end



    
