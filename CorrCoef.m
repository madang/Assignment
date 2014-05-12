function ofCC = CorrCoef(a,b )
%FCC correlation coefficient
%function ofCC = fCC(a,b )
    ma=mean(a(:));
    mb=mean(b(:));
    ofCC=mean((a(:)-ma).*(b(:)-mb))./(std(a(:),1)*std(b(:),1));

end

