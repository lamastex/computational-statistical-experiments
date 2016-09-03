% sir_cauchy_normal.m

clear all

n = 1; % number of sample points required
m = 10; % number of initial sample points

nseed = 13;
randn('state',nseed), rand('state',nseed)

y = randn(1,m);
y2 = y.*y;
w = exp(.5 * y2) ./ (1 + y2);
w = w / sum(w);
x = randsample(y,n,true,w);

s = [-4:.01:4];
s2 = s .* s;
f = (1 ./ (1 + s2)) / pi;
g = exp(-.5 * s2) / sqrt(2*pi);
plot(s,f,'-r',s,g,'-b')
legend('f=Cauchy(0,1)','g=N(0,1)')
title('Sampling/importance resampling: Generating Cauchy(0,1) using N(0,1)')
hold on, pause
plot(x(1),0,'.b',x(1),0,'ob')
plot([x(1)-.02 x(1)-.02],[.005 tpdf(x(1)-.02,1)],'-r'), text(-1.7,.05,'f(y)')
plot([x(1)+.02 x(1)+.02],[.005 normpdf(x(1)+.02,0,1)],'-b'),text(-1.3,.05,'g(y)')
text(-1.2,.03,'w prop. to f(y)/g(y)'), pause, hold off
plot(s,f,'-r',s,g,'-b')
legend('f=Cauchy(0,1)','g=N(0,1)')
title('Sampling/importance resampling: Generating Cauchy(0,1) using N(0,1)')
hold on
plot(y,zeros(1,m),'.b',y,zeros(1,m),'ob'), pause
lplot2(y,w,'v','g'), hold on, pause
plot(x,0,'.r',x,0,'or'), pause
plot(x,0,'.b',x,0,'ob')
x2 = randsample(y,n,true,w);
plot(x2,0,'.r',x2,0,'or'), pause

n = 1000; % number of sample points required
m = 10000; % number of initial sample points

nseed = 23;
randn('state',nseed), rand('state',nseed)

y = randn(1,m);
y2 = y.*y;
w = exp(.5 * y2) ./ (1 + y2);
w = w / sum(w);
x = randsample(y,n,true,w);

hold off
plot(s,f,'-r',s,g,'-b')
legend('f=Cauchy(0,1)','g=N(0,1)')
title('Sampling/importance resampling: Generating Cauchy(0,1) using N(0,1)')
hold on
plot(y,zeros(1,m),'.b')
lplot2(y,w,'v','g'), pause
plot(s,f,'-r',s,g,'-b')
legend('f=Cauchy(0,1)','g=N(0,1)')
title('Sampling/importance resampling: Generating Cauchy(0,1) using N(0,1)')
hold on
plot(x,zeros(1,n),'.r'), pause
histogram(x,1,[-inf inf],'r');

