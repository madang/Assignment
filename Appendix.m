%% LOAD STUFF
% Using what was used in readme.m - need to clean up
[ct,Te,Ve,Xray]=Driver1('materials.mat'); % question 1
Xray.original=Xray.image;
Xray.image=Xray.windowed;
[ct, Te, Ve, Xray]=Driver2( ct, Te, Ve, Xray ); % question 2

%% Get adjusted Drr
% First standart unit of \mu is reverse centimeter. Therefore for sampling
% grid of 1 millimeter we need to divide the integral by 10. Second - for
% our Xray unattenuated beams give values 255. Hence the following
iPar=[0 0 0 0 90 0];
I0=255;
voxSizeCm=0.1; %voxel size in cm, isotropicity assumed
godCoeff=0.0005; %after one try without it all value were zero. This means 
% I didn't guess the units of \mu correctly so God decided that this
% coefficient should be present in the formula
[oImage,oMask]=drr( ct, Xray, iStep, iPar);
AdjustedImage=I0*exp(-oImage*voxSizeCm*godcoeff);

%% Take a look at the result
figure;
image(AdjustedImage');
colormap(gray(256));
set(gca,'XtickLabel',[],'YTickLabel',[]);
beautify;
axis image;

%% declare an anon function for adjusting drr
adj=@(oImage)I0*exp(-oImage*voxSizeCm*godcoeff);

%% try cc optimization
%I've added a 6th parameter to iAdj, which should be true to adjust the 
%oImage. Also adjusted criterionFcn. OptimAdj script is used for iterations
 

%% Take a look at the result
figure;
image(AdjustedImage');
colormap(gray(256));
set(gca,'XtickLabel',[],'YTickLabel',[]);
beautify;
axis image;
