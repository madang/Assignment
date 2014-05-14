%% OPTIMize and try to get out of the resulting basin of attraction
iPar_opt=[0 0 0 0 0 0];
oSM_opt=0;
try_another=0;
for never=1:100
  
% oSM = @(iPar) criterionFcn( iPar, 'mi', ct, Xray );
oSM = @(iPar) criterionFcn( iPar, 'cc', ct, Xray );

%     % for large perturbations a skewed vector for perturbation makes sense
%     %(obviously not much sense to perturbe rotation, but it's good to shift in z direction
%     skewed=[2 2 2 2 2 2];

%intoduce perturbation
pert_ampl=2;
t_pert=pert_ampl*(rand(1,6)-1)*2;
iPar_pert=iPar_opt+t_pert;

%if oSM improved - use same method, else - another
if try_another
    opts = optimset('Display','iter',...
'MaxIter',200,...
'TolX',1e-4,...
'TolFun',1e-5 );
[iPar_opt,oSM_opt,flag,smth] = fminsearch( oSM, iPar_pert, opts);
save(strcat('MC_CC',num2str(never)),'iPar_opt_new','oSM_opt_new','flag','smth','try_another');
else
    % parameters of the fminunc optimization
opts = optimset('Display','iter-detailed',...
'MaxIter',200,...
'TolX',1e-4,...
'TolFun',1e-5,...
'LargeScale','off');

[iPar_opt_new,oSM_opt_new,flag,cc_minunc_out] = fminunc( oSM, iPar_pert, opts)
save(strcat('MC_CC',num2str(never)),'iPar_opt_new','oSM_opt_new','flag','cc_minunc_out','try_another');

end
otp_log(never,:)=[oSM_opt_new, flag, iPar_opt_new];
if oSM_opt_new<oSM_opt
    oSM_opt=oSM_opt_new;
    iPar_opt=iPar_opt_new;
    try_another=mod((try_another+1),2);
else
    try_another=mod((try_another+1),2);
end
%% look at the pict
oImage=drr( ct, Xray, iStep,oSM_opt_new);
imshowpair(oImage',Xray.image');
end