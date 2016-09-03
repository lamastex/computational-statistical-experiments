function cdf = unifcdf (x, a, b)

cdf=zeros(size(x));
indices = find(x>=b);
cdf(indices) = 1;
indices = find(x>=a & x<=b);
cdf(indices)=(x(indices)-a)/(b-a);

