function fx = BinomialPdf(x,n,theta)
%  Binomial probability mass function. Needs BinomialCoefficient(n,x)
%   f = BinomialPdf(x,n,theta) 
%   f is the prob mass function for the Binomial(x;n,theta) RV
%   and x can be array of samples. 
%   Values of x are integers in [0,n] and theta is a number in [0,1]
fx = zeros(size(x));
fx = arrayfun(@(xi)(BinomialCoefficient(n,xi)),x); 
fx = fx .* (theta .^ x) .* (1-theta) .^ (n-x);