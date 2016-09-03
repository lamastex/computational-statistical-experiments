function x = ExpInvSam(u,lambda);
% Return the Inverse CDF based Sample from Exponential(lambda) RV X
% Call Syntax: x = ExpInvSam(u,lambda);
%              or ExpInvSam(u,lambda);
% Input      : lambda = rate parameter, 
%              u = array of numbers in [0,1] from Uniform[0,1] RV 
% Output     : x
x=-(1/lambda) * log(u);

