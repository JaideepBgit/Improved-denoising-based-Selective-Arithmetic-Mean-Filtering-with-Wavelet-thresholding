function ssim1 = ssim(a,b)

m1 = mean(mean(a));
m2 = mean(mean(b));

sig1 = std_dev(a);
sig2 = std_dev(b);
%c1 = (255 *  0.001)^2;
%c2 = (255 *  0.001)^2;
sig12 = co_std_dev(a,b);
%ssim1 = ((2*m1*m2+c1)*(2*sig12+c2)) / ((m1^2+m2^2+c1)*(sig1^2+sig2^2+c2));
ssim1 = ((2*m1*m2)*(2*(sig12^2))) / ((m1^2+m2^2)*(sig1^2+sig2^2));
end