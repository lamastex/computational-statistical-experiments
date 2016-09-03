clf;%clear any figures
rand('twister',736343); % initialize the Uniform(0,1) Sampler
N = 3; % 10^N is the maximum number of samples from RV
J = 100; % number of Replications for each n
u = rand(J,10^N); % generate 10X10^N samples from Uniform(0,1) RV U
p=0.5; % set p for the Bernoulli(p) trials
PS=[0:0.001:1]; % sample some values for p on [0,1] to plot likelihood
for i=1:N
    if(i==1) Pmin=0.; Pmax=1.0; Ymin=-70; Ymax=-10; Y=linspace(Ymin,Ymax,J); end
    if(i==2) Pmin=0.; Pmax=1.0; Ymin=-550; Ymax=-75; Y=linspace(Ymin,Ymax,J); end
    if(i==3) Pmin=0.3; Pmax=0.8; Ymin=-900; Ymax=-700; Y=linspace(Ymin,Ymax,J); end
    n=10^i;% n= sample size, ie, number of Bernoulli trials
    subplot(1,N,i)
    if(i==1) axis([Pmin Pmax Ymin -2]); end
    if(i==2) axis([Pmin Pmax Ymin -60]); end
    if(i==3) axis([Pmin Pmax Ymin -685]); end
    EmpCovSEhat=0; % track empirical coverage for SEhat
    EmpCovSE=0; % track empirical coverage for exact SE
    for j=1:J
     % transform the Uniform(0,1) samples to n Bernoulli(p) samples
     x=floor(u(j,1:n)+p);
     s = sum(x); % statistic s is the sum of x_i's
     % display the outcomes and their sum
     %display(x) 
     %display(s) 
     MLE=s/n; % Analyticaly MLE is s/n
     se = sqrt((1-p)*p/n); % standard error from known p
     sehat = sqrt((1-MLE)*MLE/n); % estimated standard error from MLE p
     Zalphaby2 = 1.96; % for 95% CI
     if(abs(MLE-p)<=2*sehat) EmpCovSEhat=EmpCovSEhat+1; end
     line([MLE-2*sehat MLE+2*sehat],[Y(j) Y(j)],'Marker','+','LineStyle',':','LineWidth',1,'Color',[1 .0 .0])
     if(abs(MLE-p)<=2*se) EmpCovSE=EmpCovSE+1; end
     line([MLE-2*se MLE+2*se],[Y(j) Y(j)],'Marker','+','LineStyle','-')
     % l is the Log Likelihood of data x as a function of parameter p
     l=@(p)sum(log(p ^ s * (1-p)^(n-s))); 
     hold on; 
     % plot the Log Likelihood function and MLE 
     semilogx(PS,arrayfun(l,PS),'m','LineWidth',1); 
     hold on; plot([MLE],[Y(j)],'.','Color','c'); % plot MLE 
    end
    hold on;
    line([p p], [Ymin, l(p)],'LineStyle',':','Marker','none','Color','k','LineWidth',2)
    %axis([-0.1 1.1]);
    %axis square;
    LabelString=['n=' num2str(n) '  ' 'Cvrg.=' num2str(EmpCovSE) '/' num2str(J) ...
        ' ~=' num2str(EmpCovSEhat) '/' num2str(J)];
    %text(0.75,0.05,LabelString)
    title(LabelString)
    hold off;
end
