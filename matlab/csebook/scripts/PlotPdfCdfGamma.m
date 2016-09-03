lambda=0.1; % choose soem scale parameter
Xs=0:0.01:150; % choose some x values
% Plot PDFs for k=5,4,3,2,1
k=5; fXsk5=(1/gamma(k))*(lambda*exp(-lambda*Xs).*(lambda*Xs).^(k-1));% PDF for k=5
k=4; fXsk4=(1/gamma(k))*(lambda*exp(-lambda*Xs).*(lambda*Xs).^(k-1));% PDF for k=4
k=3; fXsk3=(1/gamma(k))*(lambda*exp(-lambda*Xs).*(lambda*Xs).^(k-1));% PDF for k=3
k=2; fXsk2=(1/gamma(k))*(lambda*exp(-lambda*Xs).*(lambda*Xs).^(k-1));% PDF for k=2
k=1; fXsk1=(1/gamma(k))*(lambda*exp(-lambda*Xs).*(lambda*Xs).^(k-1));% PDF for k=1
clf; % clear any previous figures
subplot(1,2,1); % make first PDF plot
plot(Xs,fXsk5, Xs, fXsk4, Xs, fXsk3, Xs, fXsk2, Xs, fXsk1)
legend('f(x;0.1,5)','f(x;0.1,4)','f(x;0.1,3)','f(x;0.1,2)','f(x;0.1,1)')
subplot(1,2,2) % make second CDF plots using MATLAB's gammainc (incomplete gamma function)
plot(Xs,gammainc(lambda*Xs,5), Xs,gammainc(lambda*Xs,4), Xs,gammainc(lambda*Xs,3),...
    Xs,gammainc(lambda*Xs,2), Xs,gammainc(lambda*Xs,1))
legend('F(x;0.1,5)','F(x;0.1,4)','F(x;0.1,3)','F(x;0.1,2)','F(x;0.1,1)')