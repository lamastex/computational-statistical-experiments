%
% Plot of mean E_p(X) and variance V_p(X) of a Bernoulli(p) RV X
% as a function of the parameter p=P(X=1) in [0,1]
%
p=[0:0.01:1]; % sample points for p in [0,1] (x-axis)
v=p .* (1-p); % evaluate V_p(X)=p*(1-p) for array p (y-axis)
plot(p,p,'r--') % plot of p versus E_p(X)
line(p,v) % plot of p versus V_p(X)
hold on
plot(p, 1-2*p,'g-.') % plot p versus d/dp V_p(X)=1-2p
% mark the coordinates where V_p(X) attains the maximum
line([0; 0.5],0.25*ones(1,2),'marker','*','linestyle',':')
line([0.5; 0.5], [0.25; 0],'marker','o','linestyle',':')


xlabel('\theta')
ylabel('Expectations of Bernoulli(\theta) RV X')
legend('E_\theta(X)=\theta','V_\theta(X)=\theta(1-\theta)','d/d\theta V_\theta(X)=1-2\theta')