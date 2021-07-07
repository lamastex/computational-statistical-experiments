OrbiterData; % load the Orbiter Data sampleTimes
% L = Log Likelihood of data x as a function of parameter lambda
L=@(lambda)sum(log(lambda*exp(-lambda * sampleTimes)));
LAMBDAS=[0.01:0.01:1]; % sample some values for lambda
clf;
subplot(1,3,1); 
semilogx(LAMBDAS,arrayfun(L,LAMBDAS)); % plot the Log Likelihood function
axis([0.05 0.25 -500 -400])
SampleMean = mean(sampleTimes) % sample mean
MLE = 1/SampleMean % ML estimate is 1/mean 
n=length(sampleTimes) % sample size
StdErr=1/(sqrt(n)*SampleMean) % Standard Error
MLE95CI=[MLE-(1.96*StdErr), MLE+(1.96*StdErr)] % 95 % CI
hold on; % plot the MLE
plot([MLE], [-500],'k.','MarkerSize',25); 
plot([MLE95CI(1)],[-500],'r.','MarkerSize',25); 
plot([MLE95CI(2)],[-500],'b.','MarkerSize',25);
 ylabel('log-likelihood'); xlabel('\lambda');
subplot(1,3,2); % plot a histogram estimate
histogram(sampleTimes,1,[min(sampleTimes),max(sampleTimes)],'m',2);
hold on; TIMES=[0.00001:0.01:max(sampleTimes)+20]; % points on support
% plot PDF at MLE and 95% CI to compare with histogram
plot(TIMES,MLE*exp(-MLE*TIMES),'k-') 
plot(TIMES,MLE*exp(-MLE95CI(1)*TIMES),'r-'); plot(TIMES,MLE*exp(-MLE95CI(2)*TIMES),'b-') 
% compare the empirical DF to the best fitted DF at MLE and 95% CI
subplot(1,3,3)
ECDF(sampleTimes,5,0.0,20); hold on; plot(TIMES,ExponentialCdf(TIMES,MLE),'k-'); 
plot(TIMES,ExponentialCdf(TIMES,MLE95CI(1)),'r-'); plot(TIMES,ExponentialCdf(TIMES,MLE95CI(2)),'b-')
ylabel('DF or empirical DF'); xlabel('support');