function [ oImage, oMask ] = drr( ct, Xray, iStep)
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
%    hold on;
%    plot3(cx,cy,cz,'ro');
    cx=cx-xs;
    cy=cy-ys;
    cz=cz-zs;
    
%     plot3(cx,cy,cz,'go');
    
    cd=sqrt(cx.*cx+cy.*cy+cz.*cz); %corner distance (from source)
    
    dmin=min(cd);
    dmax=max(cd);
    
%% Get coordinates of projection of ct.volume corners onto XRay plane
% % Yes this is a premature optimization and I will burn in hell for this but
% % I'll do this while it's still fun
% %
% % Used a plane intersection tutorial from here:
% % http://www2.math.umd.edu/~jmr/241/lines_planes.html
% 
% % Get points in the Xray plane
%   P1=[Xray.gx(1,1),Xray.gy(1,1),Xray.gz(1,1)];
%   P2=[Xray.gx(1,end),Xray.gy(1,end),Xray.gz(1,end)];
%   P3=[Xray.gx(end,end),Xray.gy(end,end),Xray.gz(end,end)];
% % Get a normal to the Cray plane
%   normal = cross(P1-P2, P1-P3);
%   
% % Get plane equation with symbolic vars
% syms x y z;
% P = [x,y,z];
% planefunction = dot(normal, P-P1);
    
%% Build a line from source to current Xray point
    kx=Xray.gx(:)-xs;
    ky=Xray.gy(:)-ys;
    kz=Xray.gz(:)-zs;
    %normalize the k vector
    kl=sqrt(kx.^2+ky.^2+kz.^2);
    kx = kx./kl;
    ky = ky./kl;
    kz = kz./kl;
    

    
%% get line points
    t=(dmin:iStep:dmax)'; %we're going to have a bunch of lines, those that are 
    % shorter  then max(kl) are going to be extended, and later trimmed
    % this way we can make use of matlab indexing to increase the speed
    lx=t*kx'+xs; %along columns - index of point in the same line
    ly=t*ky'+ys; % along rows - different lines
    lz=t*kz'+zs; % these are direct products
    
%% Calculate the integral through interpolation
    temp.gridX=lx;
    temp.gridY=ly;
    temp.gridZ=lz;
    [lx, ly, lz]=f_transform_my_grid(temp,inv(ct.currentTransform));
    
    invalid=(lx<1|lx>size(ct.gridX,1)|ly<1|ly>size(ct.gridY,2)|lz<1|lz>size(ct.gridZ,3));
    lx(invalid)=0;
    ly(invalid)=0;
    lz(invalid)=0;
    valid=not(invalid);
    interpolated_values=zeros(size(lx));
    interpolated_values(valid)=interpn(ct.gridX,ct.gridY,ct.gridZ,single(ct.volume),lx(valid),ly(valid),lz(valid),'linear',0);
    %interpn doesn't work with uint8 so there's a need for
    %single(ct.volume)
    drr_pixel_values=sum(interpolated_values); %summation along columns (dim1)
    % this is  a row vector , to get an image we need to reshape it.
    oImage=reshape(drr_pixel_values,size(Xray.image));
   
%% return oMask as well
    oMask=zeros(size(oImage));
    oMask(oImage~=0)=1;
%%


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



    
