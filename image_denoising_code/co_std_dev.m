function sig = co_std_dev(a,b)

[m,n] = size(a);

m1 = mean(mean(a));
m2 = mean(mean(b));

sum = 0;
for i = 1:m
    for j = 1:n
        diff1 = abs (m1 - a(i,j));
        diff2 = abs (m2 - b(i,j));
        sq = double(diff1*diff2);
        sum = sum + sq;
    end
end

sig = double(sum / (m*n)); %variance
sig = sqrt(sig);

end
