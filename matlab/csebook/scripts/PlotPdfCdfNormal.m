% PlotPdfCdfNormal.m script file
% Plot of some pdf's and cdf's of the Normal(mu,SigmaSq) RV X
%
x=[-6:0.0001:6]; % points from the subset [-5,5] of the support of X
subplot(1,2,1) % first plot of a 1 by 2 array of plots
plot(x,NormalPdf(x,0,1),'r') % pdf of RV Z ~ Normal(0,1)
hold % to superimpose plots
plot(x,NormalPdf(x,0,1/10),'b') % pdf of RV X ~ Normal(0,1/10)
plot(x,NormalPdf(x,0,1/100),'m') % pdf of RV X ~ Normal(0,1/100)
plot(x,NormalPdf(x,-3,1),'r--') % pdf of RV Z ~ Normal(-3,1)
plot(x,NormalPdf(x,-3,1/10),'b--') % pdf of RV X ~ Normal(-3,1/10)
plot(x,NormalPdf(x,-3,1/100),'m--') % pdf of RV X ~ Normal(-3,1/100)
xlabel('x')
ylabel('f(x; \mu, \sigma^2)')
legend('f(x;0,1)','f(x;0,10^{-1})','f(x;0,10^{-2})','f(x;-3,1)','f(x;-3,10^{-1})','f(x;-3,10^{-2})')
subplot(1,2,2) % second plot of a 1 by 2 array of plots
plot(x,NormalCdf(x,0,1),'r') % DF of RV Z ~ Normal(0,1)
hold % to superimpose plots
plot(x,NormalCdf(x,0,1/10),'b') % DF of RV X ~ Normal(0,1/10)
plot(x,NormalCdf(x,0,1/100),'m') % DF of RV X ~ Normal(0,1/100)
plot(x,NormalCdf(x,-3,1),'r--') % DF of RV Z ~ Normal(-3,1)
plot(x,NormalCdf(x,-3,1/10),'b--') % DF of RV X ~ Normal(-3,1/10)
plot(x,NormalCdf(x,-3,1/100),'m--') % DF of RV X ~ Normal(-3,1/100)
xlabel('x')
ylabel('F(x; \mu, \sigma^2)')
legend('F(x;0,1)','F(x;0,10^{-1})','F(x;0,10^{-2})','F(x;-3,1)','F(x;-3,10^{-1})','F(x;-3,10^{-2})')