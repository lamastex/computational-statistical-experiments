theta=0.5;
n=10;
SampleSize=100000;
% simulate 10000 samples from Binomial via IID Geometric RVs
Samples=arrayfun(@(T)Sim1BinomByGeoms(n,T),theta*ones(1,SampleSize));
Xs = 0:25; % get some values for x
RelFreqs=hist(Samples,Xs)/SampleSize; % relative frequencies of Samples
stem(Xs,BinomialPdf(Xs,n,theta),'*')% PDF of Binomial(n,theta)
hold on;
plot(Xs,RelFreqs,'o')% relative frequence histogram
RelFreqs1000=hist(Samples(1:1000),Xs)/1000; % Relative Frequencies of first 1000 samples
plot(Xs,RelFreqs1000,'x')
legend('PDF of Binomial(10,0.5)', 'Relative freq. hist. (100000 samples)', ...
    'Relative freq. hist. (1000 samples)')