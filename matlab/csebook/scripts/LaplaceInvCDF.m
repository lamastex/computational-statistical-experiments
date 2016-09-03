function x = LaplaceInvCDF(u,lambda);
% Call Syntax: x = LaplaceInvCDF(u,lambda);
%              or LaplaceInvCDF(u,lambda);
%
% Input      : lambda = rate parameter > 0, 
%              u = an 1 X n array of IID samples from Uniform[0,1] RV 
% Output     : an 1Xn array x of IID samples from Laplace(lambda) RV
%                                or Inverse CDF of Laplace(lambda) RV
x=-(1/lambda)*sign(u-0.5) .* log(1-2*abs(u-0.5));