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

 [ct, Te, Ve, Xray]=Driver2( ct, Te, Ve, Xray ); % question 2
 %% I have a question re question2
 % Why not inverse transform? Double-check the wording
 
 %% question 3
  iPar=[0 0 0 0 90 0 ];
 [ oX,oY,oZ ] = rigidTrans( ct, iPar);
 hold on;
 ts=150;
 plot3(oX(1:ts:end),oY(1:ts:end),oZ(1:ts:end),'.','Color','y');

plot3(oX(1),oY(1),oZ(1),'o','Color','k');


plot3(ct.gx(1),ct.gy(1),ct.gz(1),'o','Color','k');
axis image;

%% question 4 - projection
iStep=1;
% val=interpn(ct.gridX,ct.gridY,ct.gridZ,double(ct.volume),ct.gridX./2,ct.gridY./2,ct.gridZ./2);
[ oImage, oMask ] = drr( ct, Xray, iStep, iPar);
figure; imagesc(oImage);


%% question 6
%  By looking at the histogram of ct.volume one can see that background intensity is
%  64 (mode) the width o the peak is around 2. If we threshold ct.volume by
%  66 we will esentially  get rid of background.
%
%   Going to hardcode 66 into drr.
%% TODO: fix hardcoded threshold in drr

%% TODO: prepare hostograms


%% 7 CC
% % tic;teset1=CorrCoef(oImage,Xray.image);toc; % My funcion
% teset2=corrcoef(oImage,Xray.image); % Built-in
% cc=teset2(2);
VariationPlot(ct,Xray,-20:2:20,1);

%% 8 MI