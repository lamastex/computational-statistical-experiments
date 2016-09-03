function Fx = ExponentialCdf(x,Lambda)
% Returns the Cdf of Exponential(Lambda) RV at x,
% where Lambda = rate parameter
%
% Usage: Fx = ExponentialCdf(x,Lambda)
if Lambda <= 0
   error('Rate parameter Lambda must be > 0')
   return
end
Fx = 1.0 - exp(-Lambda * x);