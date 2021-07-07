% Joshu Fenemore's Data from 2007 on Waiting Times at Orbiter Bust Stop
% %The raw data -- the waiting times i minutes for each direction 
% antiTimes=[8 3 7 18 18 3 7 9 9 25 0 0 25 6 10 0 10 8 16 9 1 5 16 6 4 1 3 21 0 28 3 8 ... 
% 6 6 11 8 10 15 0 8 7 11 10 9 12 13 8 10 11 8 7 11 5 9 11 14 13 5 8 9 12 10 13 6 11 13]; 
% clockTimes=[0 0 11 1 9 5 14 16 2 10 21 1 14 2 10 24 6 1 14 14 0 14 4 11 15 0 10 2 13 2 22 ... 
% 10 5 6 13 1 13 10 11 4 7 9 12 8 16 15 14 5 10 12 9 8 0 5 13 13 6 8 4 13 15 7 11 6 23 1]; 
% sampleTimes=[antiTimes clockTimes];% pool all times into 1 array 
% % L = Log Likelihood of data x as a function of parameter lambda
% L=@(lambda)sum(log(lambda*exp(-lambda * sampleTimes)));
n=132;%sample size
LAMBDAS=[0.0002:0.001:0.30]; % sample some values for lambda
clf;
subplot(1,2,1)
c=8.0; P=@(lambda)(1-gammainc(lambda*n*c,n));
plot(LAMBDAS,arrayfun(P,LAMBDAS),'b-'); % plot the power function
hold on;
c=10.0; P=@(lambda)(1-gammainc(lambda*n*c,n));
plot(LAMBDAS,arrayfun(P,LAMBDAS),'b--'); % plot the power function
c=12.0; P=@(lambda)(1-gammainc(lambda*n*c,n));
plot(LAMBDAS,arrayfun(P,LAMBDAS),'b.-'); % plot the power function
plot([0 15],[0.05 0.05],'r--')
axis([0 0.25 -0.1 1.1])
plot([1/10 1/10], [-0.1 1.1],'g')
legend('c=8.0','c=10.0','c=12.0','\alpha =0.05','\lambda_0 =0.1')
xlabel('\lambda'); ylabel('\beta(\lambda)');
text(0.05,-0.05,'H_1'); text(0.15,-0.05,'H_0');
lambda0=1/10
S=@(C)(1-gammainc(lambda0*n*C,n));
Cs=[5:0.1:15];
subplot(1,2,2)
plot(Cs,arrayfun(S,Cs),'k'); % plot the size function
axis([5 15 -0.1 1.1])
Cs=[10 11 11.474 12 13]
Size=arrayfun(S,Cs)
hold on;
plot([0 15],[0.05 0.05],'r--')
stem([11.474],[S(11.474)])
xlabel('c'); ylabel('size'); legend('\beta(\lambda_0=0.1)','\alpha =0.05','c=11.474')