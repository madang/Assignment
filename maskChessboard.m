function oMask = maskChessboard(iMask, iW, iH, iValue1, iValue2 )
%MASKCHESSBOARD Summary of this function goes here
%   Detailed explanation goes here

canvas=ones(size(iMask))*iValue2;


for x=1:size(iMask,1)
    for y=1:size(iMask,2)
        if mod(floor(x/iW)+floor(y/iH),2)==0
            canvas(x,y)=iValue1;
        end
    end
end
oMask=canvas;
end
