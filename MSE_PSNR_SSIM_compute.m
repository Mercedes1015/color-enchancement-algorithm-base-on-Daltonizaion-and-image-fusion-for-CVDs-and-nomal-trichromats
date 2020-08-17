clear
close all
image1=double(imread('C:\Users\as\Desktop\result\protan\Simulation\sim_Daltonized_image1.png'));
image2=double(imread('C:\Users\as\Desktop\result\protan\Simulation\sim_enhanced_withLM_image1.png'));
[m,n,k]=size(image1);
MSE=sqrt(sum(sum(sum((image1-image2).^2)))./(m*n))
PSNR=psnr(image1./255,image2./255)
SSIM=ssim(image1,image2)