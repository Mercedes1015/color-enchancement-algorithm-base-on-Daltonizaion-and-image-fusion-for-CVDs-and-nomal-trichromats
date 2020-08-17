% This is the code implementation of the manuscript we submitted to Journal of Electronic Imaging
% "A color enhancing algorithm based on image fusion for color gamut reduction Daltonization"
% Author: Xuming Shen, Xiandou Zhang, Yong Wang
% Upload time: 15/08/2020 15:46
% This code is for learning and communication only. DO NOT use this code for any commercial purposes.
% And if you want to reprint, please indicate the source.

clear

%% Initialization

con_u=0.678;  % these parameter are used for protanopes
con_v=0.501; 
k=39.98;

% con_u=-1.217;   % these parameter are used for deuteranopes
% con_v=0.782; 
% k=-24.21;

img_original=double(imread('C:\Users\as\Desktop\result\protan\original_image1.png'));   
img_Daltonized=double(imread('C:\Users\as\Desktop\result\protan\daltonized_image1.png'));
[m_original,n_original,k_original]=size(img_original);                     % Note that the size of the original image and the daltonized image should be the same
img_original=img_original+0.0000001*ones(m_original,n_original,k_original);% without this step, (R,G,B)=[0 0 0] will convert to (X, Y, Z)=[0 0 0], which will result in an exception
                                                                           % where the denominator is zero for calculation of u' and v' in line 20 and line 21
img_Daltonized=img_Daltonized+0.0000001*ones(m_original,n_original,k_original);

L_Daltonized=zeros(m_original,n_original);
xyz_enhanced_with_Lightness_Modification=zeros(m_original,n_original);
xyz_enhanced_without_Lightness_Modification=zeros(m_original,n_original);
L_enhanced_with_Lightness_Modification=zeros(m_original,n_original);


%% Color Space Conversion
xyz_original=rgb2xyz(img_original./255,'WhitePoint','d65');                                             % RGB to XYZ
xyz_Daltonized=rgb2xyz(img_Daltonized./255,'WhitePoint','d65');
u_original=4*xyz_original(:,:,1)./(xyz_original(:,:,1)+15.*xyz_original(:,:,2)+3.*xyz_original(:,:,3)); % XYZ to u'v' chromaticity diagram
v_original=9*xyz_original(:,:,2)./(xyz_original(:,:,1)+15.*xyz_original(:,:,2)+3.*xyz_original(:,:,3));
u_Daltonized=4*xyz_Daltonized(:,:,1)./(xyz_Daltonized(:,:,1)+15.*xyz_Daltonized(:,:,2)+3.*xyz_Daltonized(:,:,3)); 
v_Daltonized=9*xyz_Daltonized(:,:,2)./(xyz_Daltonized(:,:,1)+15.*xyz_Daltonized(:,:,2)+3.*xyz_Daltonized(:,:,3));

% rho_original1 =sqrt( (u_original-con_u).^2+(v_original-con_v).^2);            
% rho_Daltonized =sqrt( (u_Daltonized-con_u).^2+(v_Daltonized-con_v).^2);

[theta_original,rho_original]=cart2pol((u_original-con_u),(v_original-con_v));    % u'v' to ¦Ñ¦È
[theta_Daltonized,rho_Daltonized]=cart2pol((u_Daltonized-con_u),(v_Daltonized-con_v));

%% Calculate the Lightness of the Daltonized Image
for i=1:m_original
    for j=1:n_original
        if xyz_Daltonized(i,j,2)<=0.008856
            L_Daltonized(i,j)=903.3*xyz_Daltonized(i,j,2);
        else
            L_Daltonized(i,j)=116*(xyz_Daltonized(i,j,2)).^(1/3)-16;
        end
    end
end

%% Image Fusion
theta_enhanced=theta_Daltonized;
rho_enhanced=rho_original;

[u_enhanced,v_enhanced]=pol2cart(theta_enhanced,rho_enhanced);
u_enhanced=u_enhanced+con_u;
v_enhanced=v_enhanced+con_v;

L_enhanced_without_Lightness_Modification=L_Daltonized;

%% Lightness Modification
for i = 1:m_original
    for j = 1:n_original
        
        if u_enhanced(i,j)>=u_Daltonized(i,j) %% these 4 lines correspond to the Lightness Modification in the article
            L_enhanced_with_Lightness_Modification(i,j)=L_Daltonized(i,j)+k*sqrt((u_enhanced(i,j)-u_Daltonized(i,j))^2+(v_enhanced(i,j)-v_Daltonized(i,j))^2);
        else
            L_enhanced_with_Lightness_Modification(i,j)=L_Daltonized(i,j)-k*sqrt((u_enhanced(i,j)-u_Daltonized(i,j))^2+(v_enhanced(i,j)-v_Daltonized(i,j))^2);
        end

        if L_enhanced_with_Lightness_Modification(i,j)<=7.9996
            xyz_enhanced_with_Lightness_Modification(i,j,2)=L_enhanced_with_Lightness_Modification(i,j)/903.3;
        else
            xyz_enhanced_with_Lightness_Modification(i,j,2)=((L_enhanced_with_Lightness_Modification(i,j)+16)/116)^3;
        end
        
        if L_enhanced_without_Lightness_Modification(i,j)<=7.9996
            xyz_enhanced_without_Lightness_Modification(i,j,2)=L_enhanced_without_Lightness_Modification(i,j)/903.3;
        else
            xyz_enhanced_without_Lightness_Modification(i,j,2)=((L_enhanced_without_Lightness_Modification(i,j)+16)/116)^3;
        end
    end
end

%% Color Space Conversion

xyz_enhanced_without_Lightness_Modification(:,:,1)=(9.*u_enhanced.*xyz_enhanced_without_Lightness_Modification(:,:,2))./(4.*v_enhanced);
xyz_enhanced_without_Lightness_Modification(:,:,3)=(12.*xyz_enhanced_without_Lightness_Modification(:,:,2)-3.*u_enhanced.*xyz_enhanced_without_Lightness_Modification(:,:,2)-20.*v_enhanced.*xyz_enhanced_without_Lightness_Modification(:,:,2))./(4.*v_enhanced);
img_enhanced_without_Lightness_Modification=255*xyz2rgb(xyz_enhanced_without_Lightness_Modification,'WhitePoint','d65');

xyz_enhanced_with_Lightness_Modification(:,:,1)=(9.*u_enhanced.*xyz_enhanced_with_Lightness_Modification(:,:,2))./(4.*v_enhanced);
xyz_enhanced_with_Lightness_Modification(:,:,3)=(12.*xyz_enhanced_with_Lightness_Modification(:,:,2)-3.*u_enhanced.*xyz_enhanced_with_Lightness_Modification(:,:,2)-20.*v_enhanced.*xyz_enhanced_with_Lightness_Modification(:,:,2))./(4.*v_enhanced);
img_enhanced_with_Lightness_Modification=255*xyz2rgb(xyz_enhanced_with_Lightness_Modification,'WhitePoint','d65');


%% Display and Store
figure
subplot(221)
imshow(uint8(img_original))
subplot(222)
imshow(uint8(img_Daltonized))
subplot(223)
imshow(uint8(img_enhanced_without_Lightness_Modification))
subplot(224)
imshow(uint8(img_enhanced_with_Lightness_Modification))
% imwrite(uint8(img_enhanced_without_Lightness_Modification),'C:\Users\as\Desktop\protan_image1_without_LM.png');
% imwrite(uint8(img_enhanced_with_Lightness_Modification),'C:\Users\as\Desktop\protan_image1_with_LM.png');