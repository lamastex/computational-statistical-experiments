n=100; % sample size
Mustar=100; % true mean
Sigmastar=10; % true standard deviation
rand('twister',67345); Us=rand(1,100); % draw some Uniform(0,1) samples
x=arrayfun(@(u)(Sample1NormalByNewRap(u,Mustar,Sigmastar^2)),Us); % get normal samples
Muhat=mean(x) % sample mean is MLE of Mustar 
Sigmahat=std(x) % sample standard deviation is MLE for Sigmastar
Psihat=Sigmahat/Muhat % MLE of coefficient of variation std/mean
Sehat = sqrt((1/Muhat^4)+(Sigmahat^2/(2*Muhat^2)))/sqrt(n) % standar error estimate 
ConfInt95=[Psihat-1.96*Sehat, Psihat+1.96*Sehat] % 1.96 since 1-alpha=0.95