clear

% image=double(imread('C:\Users\as\Desktop\result\protan\original_image6.png'));
% image2=double(imread('C:\Users\as\Desktop\result\protan\Daltonized_image6.png'));
% image_lab=rgb2lab(image./255);
% image2_lab=rgb2lab(image2./255);
% CIELAB_CD=mean(mean(mean(sqrt((image_lab-image2_lab).^2))))


image=double(imread('C:\Users\as\Desktop\result\protan\Simulation\sim_enhanced_withLM_image6.png'));
img_lab=rgb2lab(image./255);
L_standard_deviation=std2(img_lab(:,:,1));
u_standard_deviation=std2(img_lab(:,:,2));
v_standard_deviation=std2(img_lab(:,:,3));
standard_deviation=sqrt(L_standard_deviation^2+u_standard_deviation^2+v_standard_deviation)