function [ oct,oTe,oVe,oXray] = Driver1( fname )
%DRIVER1 A driver function for question 1
% The contrast of the vertebrae in the 2D X-ray image Xray.image can be
%  improved by intensity
% windowing.1 Transform the intensity values of the 2D X-ray image by 
% linear windowing so as to
% obtain optimal contrast of the vertebrae. The windowed 2D X-ray image 
% should be used in all
% subsequent assignments!

%% Let's first take a look at the image

load(fname);
imagesc(Xray.image');axis image; % title ('Xray.image with jet colormap using imagesc()');
% saveas(gcf,'Xray_image_imagesc_jet','eps');
t_ax=gca; %save axes as we will need them soon
% We can see the vertabrae in the center of the image. Let's use data
% cursor tool a little. Immediately above and below the vertebrae region lie
% regions of value 255. Obviously intensity of relevant structures is below
% 255. At the edges of the picture everything is equal to 0. Wrom this
% picture it is seen that the data corresponding to vertebrae lies within
% 0:255 or even narrower range.
% Let's also take look on the histogram.
% First let's find the dynamic range
min(Xray.image(:)) %=0
max(Xray.image(:)) %=956.7686
% Then build  a histogram with values in this range (just for fun)
figure; hist(Xray.image(:),957); %title('Histogram of the whole Xray.image');
beautify; saveas(gcf,'hist_whole_range','eps');
% On the histogram we can see two bars with counts of 10^4 order of
% magnitude at intensities 0 and 255. Values higher than 255 correspond (I
% checked) to the ring on the image.


%% Now let's take a look at the histogram in the region, enclosed by a pink rectangle
% (coordinates are chosen by eye, not too precisely)
axes(t_ax);
rectangle('Position',[100,170,260,120],'LineWidth',2,'EdgeColor',[1 0.05 0.05]);
beautify;
saveas(gcf,'Xray_image_pink_rectangle','eps');
relevant=Xray.image(170:290,100:360);
figure;hist(relevant(:),256);%title('Histogram of area inside rectangle');
% beautify;
saveas(gcf,'hist_relevant','eps');
% From this histogram it can be seen that it's safe to have a window form20
% to 160. Therefore center should be at 90 and width should be 140
%%
% Let's see what are the values of those
% pixels (using data cursor) to estimate windowing parmeters.
%
% It's obviously safe to window to the 0:255 range. So let's uint8 the
% image first.
% first. Of cousre the intensity in the actual region of interest never
% reaches 255.
% 
% Let's try to reuse the function from Tomaz's labs - |windowImage.m|

Xray.windowed=windowImage(Xray.image,90,140);
figure; image(Xray.windowed); colormap(gray(256)); axis image;
% beautify s;
% 
saveas(gcf,'windowed','eps');

%% Question one is finished, let's spit out all the data necessary for the next questions
 oct=ct;
 oTe=Te;
 oVe=Ve;
 oXray=Xray;
end

