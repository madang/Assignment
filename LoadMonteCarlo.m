for never=1:49
    night_cc=load(strcat('nightly',num2str(never)),'oSM_opt','iPar_opt');
    c1(never)=night_cc.oSM_opt;
    c2{never}=night_cc.iPar_opt;
end