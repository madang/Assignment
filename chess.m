function [ chessImage ] = chess( a,b,iSize )
%CHESS Summary of this function goes here
%   Detailed explanation goes here
chess_mask=maskChessboard(a,iSize,iSize,10,5);


%% 7
chessImage=a.*(chess_mask==10)+b.*(chess_mask==5);
image(chessImage); colormap(gray(256)); 

end

