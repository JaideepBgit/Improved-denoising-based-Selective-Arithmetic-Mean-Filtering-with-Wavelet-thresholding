function sig = std_dev(a)
[m,n] = size(a);
avg1 = mean(mean(a));

sum = 0;
for i = 1:m
    for j = 1:n
        diff = abs (avg1 - a(i,j));
        sq = double(diff^2);
        sum = sum + sq;
    end
end

sig = double(sum / (m*n)); %variance
sig = sqrt(sig);
end
