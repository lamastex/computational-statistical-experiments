function Cdf = Unif01Cdf (x)
% Unif01Cdf(x) returns the CDF of Uniform(0,1) RV X
% the input x can be an array
Cdf=zeros(size(x));% Cdf is an array of zeros and of the same size as x
% use the built-in find function to find the indices of x whose values are >= 1
Indices = find(x>=1);
Cdf(Indices) = 1;% Set these indices in array Cdf to 1
Indices = find(x>=0 & x<=1); % find indices of x with values in [0,1]
Cdf(Indices)=x(Indices); % set the Cdf of x in [0,1] equal to x

