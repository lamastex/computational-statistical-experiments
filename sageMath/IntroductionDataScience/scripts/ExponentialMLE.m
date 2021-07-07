% set lambda=1, n=5, and draw n samples from Exponential(lambda)
lambda=1.0; n=5; x=-(1/lambda)*log(1-rand(1,n)) 
% L = Log Likelihood of data x as a function of parameter lambda
L=@(lambda)sum(log(lambda*exp(-lambda * x)));
LAMBDAS=[0.0001:0.01:5]; % sample some values for lambda
plot(LAMBDAS,arrayfun(L,LAMBDAS)); % plot the Log Likelihood function
% Now we will find the Maximum Likelihood Estimator by finding the minimizer of -L
MLE = fminbnd(@(lambda)-sum(log(lambda*exp(-lambda * x))),0.0001,5)