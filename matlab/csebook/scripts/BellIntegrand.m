function y = BellIntegrand(x,n);
% Input      : x in [0, pi] -- may be a vector of values in [0, pi]
%              n is an integer >= 1 -- it's the n in the integrand of n-th Bell number B_n 
% Output     : y = integrand for B_n given by Cesàro (1885) -- a vector when x is a vector
y = 2*factorial(n)/(pi* exp(1)) * exp(exp(cos(x)) .* cos(sin(x))) .* ...
    sin(exp(cos(x)) .* sin(sin(x))) .* sin(n*x); 