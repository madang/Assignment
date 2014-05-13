%% A QUICK AND DIRTY MOTECARLO_ISH ALGORITHM TO USE THE COMP AT NIGHT
inpoint=0;
for never=6:10000
% oSM = @(iPar) criterionFcn( iPar, 'mi', ct, Xray );
% parameters of the simplex optimization
opts = optimset('Display','iter',...
'MaxIter',100,...
'TolX',1e-4,...
'TolFun',1e-5 );
inpoint=inpoint+rand(1,6);
[iPar_opt,oSM_opt,flag,smth] = fminsearch( oSM, inpoint, opts);

save(strcat('nightly',num2str(never)));
end