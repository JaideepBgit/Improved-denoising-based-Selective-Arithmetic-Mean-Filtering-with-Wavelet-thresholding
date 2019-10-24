%tsamf for lena.bmp
orig=imread('lena1.bmp');
[x y] = size(orig);
noise=input('Enter the noise to be added(< 0 and >1');
tol=input('Enter the tolerance value');
temp_img = imnoise(orig,'salt & pepper',noise);
imshow(temp_img);
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
             %cumu = 0;
             count = 0;
             for l= 1 : 3
               for m = 1 : 3
                   if(temp(l,m) ~= 0 && temp(l,m) ~=255 )
                      % cumu= cumu + double(temp(l,m));
                      inf =[inf double(temp(1,m))];
                       count = count + 1;
                   end
               end
             end
             if (count > 3)    
                %cumu = cumu /count ;
                cumu = (median(inf));
                if (a(k,j) == 255)
                     diff = abs( a(k,j)- cumu);
                 else
                     diff = abs( cumu-a(k,j));
                end
                if( diff > tol )
                    a(k,j) = cumu;
                end
             else
                 %cumu = double(sum(double(sum(double(a((k-1):(k+1),(j-1):(j+1)))))));
                 inf = [inf double(a((k-1):(k+1),(j-1):(j+1)))];
                 cumu =(median(inf));
                 a(k,j) = cumu;
             end
           end
       end
  end
   
 for i = 1 : x
    for j = 1 : y
        temp_img(i,j) = a(i+2,j+2);
    end
end

diff1 = orig - temp_img;
sq_er1 = double(diff1.^2);
mse1 = mean(mean(sq_er1));
psnr1 = 10*log10(255^2/mse1);



display(psnr1);
ssim2 = ssim(orig,temp_img)
corr_1 = corr2(orig,temp_img)
figure;
imshow(orig)
figure;
imshow(temp_img);
imwrite(temp_img,'1_40.jpg');
