lambda=10.0; % declare lambda
x=0:50;
PoissPdf = exp(-lambda) * lambda .^ x ./ factorial(x);
stem(x,PoissPdf,'*')
hold on
NumSamples=1000;
rand('twister',10098);
PoissSim=arrayfun(@(L)Sim1Poisson(L),lambda*ones(1,NumSamples));
PoissSamples=hist(PoissSim,x);
plot(x,PoissSamples/NumSamples,'o')
legend('PDF of Poisson(10)', 'Relative freq. hist. (1000 samples)')