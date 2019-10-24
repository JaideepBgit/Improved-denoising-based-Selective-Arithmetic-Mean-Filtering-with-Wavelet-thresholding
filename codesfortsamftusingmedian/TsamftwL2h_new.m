%tsamf for lena.bmp
clc
clear all
close all
orig=imread('lena1.bmp');
[x y] = size(orig);
noise=input('Enter the noise to be added(< 0 and >1');
tol=input('Enter the tolerance value');
temp_img = imnoise(orig,'salt & pepper',noise);

temp = ones(3);
a = ones(x+4,y+4);
for i = 3 : x+2
    for j = 3 : y+2
        a(i,j) = temp_img(i-2, j-2);
    end
end
  for j = 3 : y+2
        for k= 3 : x+2
          if (a(k,j) == 255 || a(k,j) == 0 )
             temp = a((k-1):(k+1),(j-1):(j+1));
             inf=[];
%              cumu = 0;
             count = 0;
             for l= 1 : 3
               for m = 1 : 3
                   if(temp(l,m) ~= 0 && temp(l,m) ~=255 )
%                        cumu= cumu + double(temp(l,m));
                         inf=[inf double(temp(1,m))];
                       count = count + 1;
                   end
               end
             end
             if (count > 3)    
                 cumu=median(inf);
%                 cumu = cumu /count ;
                if (a(k,j) == 255)
                     diff = abs( a(k,j)- cumu);
                 else
                     diff = abs( cumu-a(k,j));
                end
                if( diff > tol )
                    a(k,j) = cumu;
                end
             else
%                  cumu = double(sum(double(sum(double(a((k-1):(k+1),(j-1):(j+1)))))));
                inf=[inf double(a((k-1):(k+1),(j-1):(j+1)))];
                 cumu = median(inf);
                 a(k,j) = cumu;
             end
           end
       end
  end
   
 for i = 1 : x
    for j = 1 : y
        Im_dup(i,j) = a(i+2,j+2);
    end
end
%wavelet
[cA,cH,cV,cD] = swt2(double(Im_dup),2,'db4');
th=2;
for i = 1:2
    
    thr_h = th*std_dev(cH(:,:,i));
    thr_v = th*std_dev(cV(:,:,i));
    thr_d = th*std_dev(cD(:,:,i));
    
    sorh = 'h';
    cH(:,:,i) = wthresh(cH(:,:,i),sorh,thr_h);
    cV(:,:,i) = wthresh(cV(:,:,i),sorh,thr_v);
    cD(:,:,i) = wthresh(cD(:,:,i),sorh,thr_d);
end

clean = iswt2(cA,cH,cV,cD,'db4');
Im_dup = uint8(wcodemat(clean,256));

diff1 = orig - Im_dup;
sq_er1 = double(diff1.^2);
mse1 = mean(mean(sq_er1));
psnr1 = 10*log10(255^2/mse1);



display(psnr1);
ssim2 = ssim(orig,Im_dup)
corr_1 = corr2(double(orig),Im_dup)
imwrite(Im_dup,'tsamfwL2h.jpg');
figure(1)
imshow(temp_img);
figure(2)
imshow(Im_dup);
