%% OPTIMize and try to get out of the resulting basin of attraction
 iPar_opt=[-1.20652456215654,-1.52095841676599,-1.39033043105320,-1.45002942032096,-1.72012281734266,-1.66931110663657]
 oSM_opt=[-1.89005360451530]
 try_another=0;
 %% some utities
 I0=255;
voxSizeCm=0.1; %voxel size in cm, isotropicity assumed
godCoeff=0.0005; %after one try without it all value were zero. This means 
 adj=@(oImage)I0*exp(-oImage*voxSizeCm*godCoeff);
%%
for never=53:10000
  
% oSM = @(iPar) criterionFcn( iPar, 'mi', ct, Xray );
oSM = @(iPar) criterionFcn( iPar, 'mi', ct, Xray );

%     % for large perturbations a skewed vector for perturbation makes sense
%     %(obviously not much sense to perturbe rotation, but it's good to shift in z direction
%     skewed=[2 2 2 2 2 2];

%intoduce perturbation
pert_ampl=0.1;
t_pert=pert_ampl*(rand(1,6)-1)*2;
iPar_pert=iPar_opt+t_pert;

%if oSM improved - use same method, else - another
if try_another
    %simplex
    opts = optimset('Display','iter',...
'MaxIter',200,...
'TolX',1e-4,...
'TolFun',1e-5 );
[iPar_opt_new,oSM_opt_new,flag,smth] = fminsearch( oSM, iPar_pert, opts)
save(strcat('MC_CC',num2str(never)),'iPar_opt_new','oSM_opt_new','flag','smth','try_another');
else
    % parameters of the fminunc optimization
opts = optimset('Display','iter-detailed',...
'MaxIter',200,...
'TolX',1e-5,...
'TolFun',1e-6,...
'LargeScale','off');

[iPar_opt_new,oSM_opt_new,flag,cc_minunc_out] = fminunc( oSM, iPar_pert, opts)
save(strcat('ADj_OPTI',num2str(never)),'iPar_opt_new','oSM_opt_new','flag','cc_minunc_out','try_another');

end
adj_opt_log(never,:)=[oSM_opt_new, flag, iPar_opt_new];
if oSM_opt_new<oSM_opt
    oSM_opt=oSM_opt_new;
    iPar_opt=iPar_opt_new;
    
else
    try_another=mod((try_another+1),2);
end
%% look at the pict
oImage=drr( ct, Xray, iStep,iPar_opt_new);
% imshowpair(255-adj(oImage)',255-Xray.image');
% axis image;
% drawnow;

%% chess
chess(adj(oImage)',Xray.image',25);
axis image;
drawnow;
end