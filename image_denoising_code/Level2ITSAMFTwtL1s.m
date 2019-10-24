% THIS PROGRAM PERFORMS MODIFIED TSAMF ON GIVEN INPUT 
% IMAGE AND  THEN PERFORMS 1 LEVEL SWT. SOFT
% THRESHOLDING  IS APPLIED ON EACH SUB-BAND.
%
orig=imread('lena1.bmp');
[x y] = size(orig);
noise=input('Enter the noise to be added(< 0 and >1');
tol=input('Enter the tolerance value');
th=2;%input('Enter the threshold value');
a = imnoise(orig,'salt & pepper',noise);
figure(1)
imshow(a);
temp_img = zeros(x+4,y+4);
temp_img1 = zeros(x+4,y+4);
for i = 3 : x+2
    for j = 3 : y+2
        temp_img(i,j) = a(i-2, j-2);
    end
end
temp_img = uint8(temp_img);

temp = uint8(ones(3));

for j = 3 : y+2
    for k= 3 : x+2
        
        if (temp_img(k,j) == 255 || temp_img(k,j) == 0 )
            temp = temp_img((k-1):(k+1),(j-1):(j+1));
            cumu = 0;
            count = 0;
            for l= 1 : 3
                for m = 1 : 3
                    if(temp(l,m) ~= 0 && temp(l,m) ~=255 )
                        cumu= cumu + double(temp(l,m));
                        count = count + 1;
                    end
                end
            end

            if (count >= 1)
                
                cumu = cumu /count ;
                if (temp_img(k,j) == 255)
                     diff = abs(temp_img(k,j) - cumu);
                 else
                     diff = abs(cumu - temp_img(k,j));
                end
                if( diff > tol )
                    temp_img1(k,j) = cumu;
                end
            else
                
                temp1 = temp_img((k-2):(k+2),(j-2):(j+2));
                cumu1 = 0;
                count1 = 0;
                cumu2 = 0;
                count2 = 0;
                init = 1;
                for c = 1 : 5
                    for d = 1 : 5
                        if(temp1(c,d) ~= 0 && temp1(c,d) ~=255 )
                            if( init == 1)
                            t = temp1(c,d);
                            init = 0;
                            end   
                            if(temp1(c,d) >= (t-5) && temp1(c,d) <= (t+5))
                                cumu1 = cumu1 + double(temp1(c,d));
                                count1 = count1 + 1;
                            else
                                cumu2 = cumu2 + double(temp1(c,d));
                                count2 = count2 + 1;
                            end
                        end
                    end
                end

                if (count1 >= 1 || count2 >= 1)
                    if(count1 >= count2)
                        cumu1 = cumu1 /count1;
                    else
                        cumu1 = cumu2 /count2;
                    end
                    if (temp_img(k,j) == 255)
                        diff1 = abs(temp_img(k,j) - cumu1);
                    else
                        diff1 = abs(cumu1 - temp_img(k,j));
                    end

                    if( diff1 > tol )
                        temp_img1(k,j) = cumu1;
                    end
                else
                    temp_img1(k,j) = temp_img(k,j);
                end
            end

        else
            temp_img1(k,j) = temp_img(k,j);
        end
    end
end

for i = 1 : x
    for j = 1 : y
        Im_dup(i,j) = temp_img1(i+2,j+2);
    end
end

temp_img = uint8(temp_img1);

for j = 3 : y+2
    for k= 3 : x+2        
        if (temp_img(k,j) == 255 || temp_img(k,j) == 0 )
            temp = temp_img((k-1):(k+1),(j-1):(j+1));
            cumu = 0;
            count = 0;
            for l= 1 : 3
                for m = 1 : 3
                    if(temp(l,m) ~= 0 && temp(l,m) ~=255 )
                        cumu= cumu + double(temp(l,m));
                        count = count + 1;
                    end
                end
            end

            if (count >= 4)
                
                cumu = cumu /count ;
                if (temp_img(k,j) == 255)
                     diff = abs(temp_img(k,j) - cumu);
                 else
                     diff = abs(cumu - temp_img(k,j));
                end
                if( diff > tol )
                    temp_img(k,j) = cumu;
                end
            else
                
                temp1 = temp_img((k-2):(k+2),(j-2):(j+2));
                cumu1 = 0;
                count1 = 0;
                cumu2 = 0;
                count2 = 0;
                init = 1;
                for c = 1 : 5
                    for d = 1 : 5
                        if(temp1(c,d) ~= 0 && temp1(c,d) ~=255 )
                            if( init == 1)
                            t = temp1(c,d);
                            init = 0;
                            end   
                            if(temp1(c,d) >= (t-10) && temp1(c,d) <= (t+10))
                                cumu1 = cumu1 + double(temp1(c,d));
                                count1 = count1 + 1;
                            else
                                cumu2 = cumu2 + double(temp1(c,d));
                                count2 = count2 + 1;
                            end
                        end
                    end
                end

                if (count1 >= 1 || count2 >= 1)
                    if(count1 >= count2)
                        cumu1 = cumu1 /count1;
                    else
                        cumu1 = cumu2 /count2;
                    end
                    if (temp_img(k,j) == 255)
                        diff1 = abs(temp_img(k,j) - cumu1);
                    else
                        diff1 = abs(cumu1 - temp_img(k,j));
                    end

                    if( diff1 > tol )
                        temp_img(k,j) = cumu1;
                    end
                end    
            end
        end
    end
end

for i = 1 : x
    for j = 1 : y
        Im_dup(i,j) = temp_img(i+2,j+2);        
    end
end

%wavelet
[cA,cH,cV,cD] = swt2(double(Im_dup),1,'db4');

for i = 1:1
    
    thr_h = th*std_dev(cH(:,:,i));
    thr_v = th*std_dev(cV(:,:,i));
    thr_d = th*std_dev(cD(:,:,i));
    
    sorh = 's';
    cH(:,:,i) = wthresh(cH(:,:,i),sorh,thr_h);
    cV(:,:,i) = wthresh(cV(:,:,i),sorh,thr_v);
    cD(:,:,i) = wthresh(cD(:,:,i),sorh,thr_d);
end

clean = iswt2(cA,cH,cV,cD,'db4');
Im_dup = uint8(wcodemat(clean,256));

diff1 = orig - Im_dup;
sq_er1 = double(diff1.^2);
mse1 = mean(mean(sq_er1));
psnr1 = 10*log10(255^2/mse1)
ssim2 = ssim(orig, Im_dup)
corr_1 = corr2(orig,Im_dup)

imwrite(uint8(Im_dup),'Level2ITSAMFTwtL1s.jpg');
figure(2)
imshow(Im_dup);

display('*********************');