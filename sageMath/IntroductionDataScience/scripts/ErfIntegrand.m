function y = ErfIntegrand(x);
% return the integrand of error function called erf in Matlab
y = ( 2 / (sqrt(pi)) ) * exp(-x .^ 2); % using .^ for vectorized squaring