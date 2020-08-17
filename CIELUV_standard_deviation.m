clear
image=double(imread('C:\Users\as\Desktop\result\protan\Simulation\sim_original_image1.png'));

WHITEPOINT=[0.950456,1,1.088754];
WHITEPOINTU=(4*WHITEPOINT(1))./(WHITEPOINT(1)+15*WHITEPOINT(2)+3*WHITEPOINT(3));
WHITEPOINTV=(9*WHITEPOINT(1))./(WHITEPOINT(1)+15*WHITEPOINT(2)+3*WHITEPOINT(3));
[m,n,k]=size(image);
image=image+0.000000001*ones(m,n,k);
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

L_standard_deviation=std2(L_star);
u_standard_deviation=std2(u_star);
v_standard_deviation=std2(v_star);
standard_deviation=sqrt(L_standard_deviation^2+u_standard_deviation^2+v_standard_deviation)
