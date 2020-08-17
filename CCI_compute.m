%% CCI
clear
img=double(imread('C:\Users\as\Desktop\result\protan\Daltonized_image1.png'));
[m,n,k]=size(img);
img_hsv=rgb2hsv(img);
S_average=mean(mean(img_hsv(:,:,2)));
S_standarddeviation=sqrt(sum(sum(1/(m*n).*(img_hsv(:,:,2)-S_average.*ones(m,n)).^2)));
CCI=S_average+S_standarddeviation