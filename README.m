sc=@(a) a*255/max(a(:));
%% IMPORTANT NOTES
%% 1
% If $\mu$ is attenuation coefficient than integral along beams is an
% incorrect pixel value for projection. Correct pixel value would be
% $I=I_{0}e^{-\int \mu(l) dl}$. Even if use the linear term to approximate
% the value of this exponent, still we will have $I_{0}(1-\int \mu(l)dl)$

%% TODO
%% 1 
% If profiling shows it makes sense exclude beams that don't


%%
[ct,Te,Ve,Xray]=Driver1('materials.mat'); % question 1
Xray.original=Xray.image;
Xray.image=Xray.windowed;
%%
[ct, Te, Ve, Xray]=Driver2( ct, Te, Ve, Xray ); % question 2

 %% question 3
  iPar=[0 0 0 90 0 0 ];
 [ oX,oY,oZ ] = rigidTrans( ct, iPar);
 hold off;
 figure;
 ts=1;% spacing to speed up plots interaction
plot3(Xray.gx(1:ts:end),Xray.gy(1:ts:end),Xray.gz(1:ts:end),'.','Color','b');
grid on;
hold on;
% Yellow for ct
 plot3(oX(1:ts:end),oY(1:ts:end),oZ(1:ts:end),'.','Color','y');
 
 % Magenta for source
 plot3(Xray.SPos(1),Xray.SPos(2),Xray.SPos(3),'.','Color','m')
beautify;
% saveas(gcf,'question4','eps');
% plot3(oX(1),oY(1),oZ(1),'o','Color','k');
% 
% 
% plot3(ct.gx(1),ct.gy(1),ct.gz(1),'o','Color','k');


% axis image;

%% question 4 - projection
iPar=[0 0 0 0 0 0];
iStep=1;
% val=interpn(ct.gridX,ct.gridY,ct.gridZ,double(ct.volume),ct.gridX./2,ct.gridY./2,ct.gridZ./2);
[ oImage, oMask ] = drr( ct, Xray, iStep, iPar);

oImage=oImage*255/max(oImage(:));
figure; image(oImage'); colormap(gray(256));
set(gca,'XTickLabel',[],'YTickLabel',[]);
axis image;
beautify(2,'s');



%% question 6
%  By looking at the histogram of ct.volume one can see that background intensity is
%  64 (mode) the width o the peak is around 2. If we threshold ct.volume by
%  66 we will esentially  get rid of background.
%
hist(ct.volume(:),1:128);

%   Going to hardcode 66 into drr.
%% TODO: fix hardcoded threshold in drr

%% TODO: prepare histograms


%% 7 CC
% % tic;teset1=CorrCoef(oImage,Xray.image);toc; % My funcion from labs
% teset2=corrcoef(oImage,Xray.image); % Built-in
% cc=teset2(2);

VariationPlotCC(ct,Xray,-20:2:20,1,'tx');
VariationPlotCC(ct,Xray,-20:2:20,2,'ty');
VariationPlotCC(ct,Xray,-20:2:20,3,'tz');
VariationPlotCC(ct,Xray,-10:1:10,4,'alpha');
VariationPlotCC(ct,Xray,-10:1:10,5,'beta');
VariationPlotCC(ct,Xray,-10:1:10,6,'gamma');
%% 8 MI
VariationPlotMI(ct,Xray,-20:2:20,1,'tx');
VariationPlotMI(ct,Xray,-20:2:20,2,'ty');
VariationPlotMI(ct,Xray,-20:2:20,3,'tz');
VariationPlotMI(ct,Xray,-10:1:10,4,'alpha');
VariationPlotMI(ct,Xray,-10:1:10,5,'beta');
VariationPlotMI(ct,Xray,-10:1:10,6,'gamma');

%% 9 Optimize
partial_mins=[-20 -14 20 -10 10 10];
% definition of similarity measure SM(p)
oSM = @(iPar) criterionFcn( iPar, 'cc', ct, Xray );
% parameters of the simplex optimization
opts = optimset('Display','iter',...
'MaxIter',200,...
'TolX',1e-4,...
'TolFun',1e-4 );

[iPar_opt,oSM_opt,flag,cc_minsearch_out] = fminsearch( oSM, partial_mins, opts )

%% look at the pict
oImage=drr( ct, Xray, iStep,iPar_opt);
imshowpair(oImage,Xray.image);
%% On first optimization saved whole workspace to OPTCC1.mat


%% CC and fminunc 
t_pert=20*(rand(1,6)-1)*2;
oSM = @(iPar) criterionFcn( iPar, 'cc', ct, Xray );
% parameters of the simplex optimization
opts = optimset('Display','iter-detailed',...
'MaxIter',200,...
'TolX',1e-4,...
'TolFun',1e-4,...
'LargeScale','off');
iPar_pert=iPar_opt+t_pert;
% iPar_pert=[0 0 0 0 0 0];
[iPar_opt,oSM_opt,flag,cc_minunc_out] = fminunc( oSM, [0 0 0 0 0 0], opts)
%% USE OPTIM.m to introduce random perturbations


%% look at the pict
oImage=drr( ct, Xray, iStep,iPar_opt);
figure;
imshowpair(oImage',Xray.image');


%% 9.2 Optimize MI
% definition of similarity measure SM(p)
oSM = @(iPar) criterionFcn( iPar, 'mi', ct, Xray );
% parameters of the simplex optimization
opts = optimset('Display','iter',...
'MaxIter',200,...
'TolX',1e-3,...
'TolFun',1e-3 );
[iPar_opt,oSM_opt,flag,smth] = fminsearch( oSM, [0 0 0 0 0 0], opts);




%% 9.4 MI and fminunc
% definition of similarity measure SM(p)
oSM = @(iPar) criterionFcn( iPar, 'mi', ct, Xray );
% parameters of the simplex optimization
% parameters of the simplex optimization
opts = optimset('Display','iter-detailed',...
'MaxIter',200,...
'TolX',1e-4,...
'TolFun',1e-4,...
'LargeScale','off');
[iPar_opt,oSM_opt,flag,cc_minunc_out] = fminunc( oSM, [0 0 0 0 0 0], opts);
%% look at the pict
oImage=drr( ct, Xray, iStep,iPar_opt);
imshowpair(oImage',Xray.image');
% chess(sc(oImage),Xray.image,30);

%% show a zoomed pict
iImage=drr( ct, Xray, iStep,[0 0 0 0 0 0]);
rx=100:300;
ry=250:400; %ranges x and y
figure;
image(sc(iImage(rx,ry))');
colormap(gray(256));
set(gca,'XtickLabel',[],'YTickLabel',[]);
beautify;
axis image;

%% same for oImage
figure;
image(sc(oImage(rx,ry))');
colormap(gray(256));
set(gca,'XtickLabel',[],'YTickLabel',[]);
beautify;
axis image;

%% same for Xray.image

figure;
image(Xray.image(rx,ry)');
colormap(gray(256));
set(gca,'XtickLabel',[],'YTickLabel',[]);
beautify;
axis image;

%% chess
figure;
chess(sc(oImage(rx,ry))',Xray.image(rx,ry)',25);
colormap(gray(256));
set(gca,'XtickLabel',[],'YTickLabel',[]);
beautify;
axis image;


%% SCREW
% Get 2nd point
Ee=Te+20*Ve;
g=[Te;Ee];
h=g;
[hx,hy,hz]=f_transform_my_grid(h(:,1),g(:,2),g(:,3),ct.TPos); %we're in the world coords now


    temp1.gx=hx;
    temp1.gy=hy;
    temp1.gz=hz;
    [cx,cy,cz]=rigidTrans(temp1,iPar_opt);

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
points=[cx,cy,cz];
src=repmat(Xray.SPos,2,1);
lines=src+t*(points-src);
IntersectionPoints=zeros(2,3);
for ind =1:2
    newfunction = subs(planefunction, P, lines(ind,:));
    t0(ind) = solve(newfunction);
    IntersectionPoints(ind,:) = subs(lines(ind,:), t, t0(ind));
%     ezplot3(lines(1,1),lines(1,2),lines(1,3),[0,t0]);
end

%get intersection points inintristic coordiantes of Xray.image

[ipx,ipy,ipz]=f_transform_my_grid(IntersectionPoints(:,1),...
    IntersectionPoints(:,2),IntersectionPoints(:,3),inv(Xray.TPos));
image(Xray.image');colormap(gray(256));axis image;
line(ipx,ipy,'Color','r','LineWidth',3)
%%

% %%
% % center of CT
% 
% cx=(ct.gx(ceil((numel(ct.gx)+1)/2))+ct.gx(floor((numel(ct.gx)+1)/2)))/2;
% cy=(ct.gy(ceil((numel(ct.gy)+1)/2))+ct.gy(floor((numel(ct.gy)+1)/2)))/2;
% cz=(ct.gz(ceil((numel(ct.gz)+1)/2))+ct.gz(floor((numel(ct.gz)+1)/2)))/2;


