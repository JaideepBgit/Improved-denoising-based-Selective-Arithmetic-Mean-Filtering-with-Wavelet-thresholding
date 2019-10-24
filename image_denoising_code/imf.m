% THIS PROGRAM PERFORMS MODIFIED TSAMF ON GIVEN INPUT
% IMAGE AND  THEN PERFORMS 1 LEVEL SWT. SOFT
% THRESHOLDING  IS APPLIED ON EACH SUB-BAND.
%
clear all
clc
orig=imread('lenam.jpg');
[x y] = size(orig);
noise=0.90;
% noise=input('Enter the noise to be added(< 0 and >1');
a = imnoise(orig,'salt & pepper',noise);
imshow(a);
th_old=0;
temp_img = zeros(x+4,y+4);
temp_img1 = zeros(x+4,y+4);
for i = 3 : x+2
    for j = 3 : y+2
        temp_img(i,j) = a(i-2, j-2);
    end
end
temp_img = uint8(temp_img);
mean_tmp=0;
[p q]=size(orig)
n_mat=zeros(p+2,q+2);
for j = 3 : y+2
    for k= 3 : x+2
        if (temp_img(k,j) == 255 || temp_img(k,j) ==0)
        if (temp_img(k,j) == 255)
            temp = temp_img((k-1):(k+1),(j-1):(j+1));
            temp=reshape(temp,1,[]);
            temp=temp(5)-temp;
            mean_tmp=sum(temp)/8;
        elseif(temp_img(k,j) ==0)
            temp = temp_img((k-1):(k+1),(j-1):(j+1));
            temp=reshape(temp,1,[]);
            temp=temp;
            mean_tmp=sum(temp)/8;
        end
        if(mean_tmp>th_old)
        n_mat(k,j)=1;
        end
        end
    end
end 
f1=0;
inf=[];
for j = 3 : y
    for k= 3 : x
       if(n_mat(k,j)) 
       for p=-1:1
          for q= -1:1
           if(~n_mat(k+p,j+q))
           inf=[inf,uint8(temp_img(k+p,j+q))];
          f1=1;
          end
         end
       end
    if(f1)
    temp_img(k,j)=median(inf);
    inf=[];
    f1=0;
    else
    for p=-2:2
        for q= -2:2
          if(~n_mat(k+p,j+q))
          inf=[inf,temp_img(k+p,j+q)];
          f1=1;
          end
        end
    end
    if(f1)
        temp_img(k,j)=median(inf);
        f1=0;
        inf=[];
    end
    end
    end

    end 
end
for i = 1 : y
    for j = 1 : x
        Im_dup(i,j) = temp_img(i+2,j+2);        
    end
end

imshow(a);
figure;
imshow(Im_dup);
Im = uint8(Im_dup);
diff1 = orig - Im;
sq_er1 = double(diff1.^2);
mse1 = mean(mean(sq_er1));
psnr1 = 10*log10(255^2/mse1)
ssim2 = ssim(orig, Im);
corr_1 = corr2(orig,Im)

imwrite(a,'noise.jpg');
imwrite(Im_dup,'t1.jpg');
display('*********************');