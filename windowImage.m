function wImage = windowImage( iImage, iCenter, iWidth, iOutputDynamicRange )
%WINDOWIMAGE grayscale windowing of an image
%   function [ output_args ] = windowImage( iImage, iCenter, iWidth)
%       performs grayscale windowing to a 0:255 output range
%
%    function [ output_args ] = windowImage( iImage, iCenter, iWidth, iOutputDynamicRange )
%       performs grayscale windowing to arbitrary range format: [ low high]

%% parse input
if nargin<4
    iOutputDynamicRange=[0 255];
end

%% Set lo and hi
outlo=min(iOutputDynamicRange);
outhi=max(iOutputDynamicRange);

lo=iCenter-iWidth/2;
hi=iCenter+iWidth/2;
    wImage=NaN(size(iImage));
    wImage(iImage<=lo)=outlo;
    wImage(iImage>hi-1)=outhi;
%% Window
    wImage(isnan(wImage))=((outhi-outlo+1)/iWidth)*(iImage(isnan(wImage))-lo)+outlo;

end

