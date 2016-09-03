function x = ExpInvCDF(u,lambda);
% Return the Inverse CDF of Exponential(lambda) RV X
% Call Syntax: x = ExpInvCDF(u,lambda);
%              ExpInvCDF(u,lambda);
% Input      : lambda = rate parameter, 
%              u = array of numbers in [0,1]  
% Output     : x
x=-(1/lambda) * log(1-u);
