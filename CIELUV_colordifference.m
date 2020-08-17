clear
image=double(imread('C:\Users\as\Desktop\result\deuteran\Simulation\sim_Daltonized_image2.png'));
image2=double(imread('C:\Users\as\Desktop\result\deuteran\Simulation\sim_enhanced_withoutLM_image2.png'));

WHITEPOINT=[0.950456,1,1.088754];
WHITEPOINTU=(4*WHITEPOINT(1))./(WHITEPOINT(1)+15*WHITEPOINT(2)+3*WHITEPOINT(3));
WHITEPOINTV=(9*WHITEPOINT(1))./(WHITEPOINT(1)+15*WHITEPOINT(2)+3*WHITEPOINT(3));
[m,n,k]=size(image);
image=image+0.0000001*ones(m,n,k);  % without this step, (R,G,B)=[0 0 0] will convert to (X, Y, Z)=[0 0 0], 
                                    % which will result in an exception
                                    % where the denominator is zero for
                                    % calculation of u' and v' in line 16
                                    % and line 17
L_star=zeros(m,n);
xyz=rgb2xyz(image./255,'WhitePoint','d65');
u=4*xyz(:,:,1)./(xyz(:,:,1)+15.*xyz(:,:,2)+3.*xyz(:,:,3));
v=9*xyz(:,:,2)./(xyz(:,:,1)+15.*xyz(:,:,2)+3.*xyz(:,:,3));
for i=1:m
    for j=1:n
        if xyz(i,j,2)<=0.008856
            L_star(i,j)=903.3*xyz(i,j,2);
        else
            L_star(i,j)=116*(xyz(i,j,2)).^(1/3)-16;
        end
    end
end
u_star=13.*L_star.*(u-WHITEPOINTU.*ones(m,n)); 	 
v_star=13.*L_star.*(v-WHITEPOINTV.*ones(m,n));


image2=image2+0.0000001*ones(m,n,k);
L2_star=zeros(m,n);
xyz2=rgb2xyz(image2./255,'WhitePoint','d65');
u2=4*xyz2(:,:,1)./(xyz2(:,:,1)+15.*xyz2(:,:,2)+3.*xyz2(:,:,3));
v2=9*xyz2(:,:,2)./(xyz2(:,:,1)+15.*xyz2(:,:,2)+3.*xyz2(:,:,3));
for i1=1:m
    for j1=1:n
        if xyz2(i1,j1,2)<=0.008856
            L2_star(i1,j1)=903.3*xyz2(i1,j1,2);
        else
            L2_star(i1,j1)=116*(xyz2(i1,j1,2)).^(1/3)-16;
        end
    end
end
u2_star=13.*L2_star.*(u2-WHITEPOINTU.*ones(m,n));
v2_star=13.*L2_star.*(v2-WHITEPOINTV.*ones(m,n));

colordiffenceinLuv = mean(mean(sqrt((L_star-L2_star).^2+(u_star-u2_star).^2 +(v_star-v2_star).^2)))