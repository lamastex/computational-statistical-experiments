function fx = ExponentialPdf(x,Lambda)
% Returns the Pdf of Exponential(Lambda) RV at x,
% where Lambda = rate parameter
%
% Usage: fx = ExponentialPdf(x,Lambda)
if Lambda <= 0
   error('Rate parameter Lambda must be > 0')
   return
end

fx = Lambda * exp(-Lambda * x);