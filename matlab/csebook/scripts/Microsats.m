load ACrepeatsHCM.dat 
% read data from Microsats Human Chimp Mouse AC OrthologousRepeats 
% Evolution and conservation of microsaellites in vertebrate genomes PhD dissertation Manu 2008

a=6;
b=45;
%b=102;
u=[a:0.001:b];
%semilogx(u,(u-a)/(b-a),'k'); % plot the DF of Uniform(0,1) RV in black
plot(u,(u-a)/(b-a),'k'); % plot the DF of Uniform(0,1) RV in black
axis([a b 0 1])
hold on;   
% calling a more efficient ECDF2 function for empirical DF's
[x1 y1]=ECDF2(ACrepeatsHCM(:,1),0,0,0); % Human
[x2 y2]=ECDF2(ACrepeatsHCM(:,2),0,0,0); % Chimp
%[x3 y3]=ECDF2(ACrepeatsHCM(:,3),0,0,0); % Mouse
stairs(x1,y1,'r','linewidth',2) % draw the empirical DF for first dataset
hold on;
stairs(x2,y2,'b','linewidth',2) % draw empirical cdf for second dataset
hold on;
%stairs(x3,y3,'m','linewidth',2) % draw empirical cdf for second dataset

% set plot labels and legends and title
xlabel('AC repeat length x')
ylabel('ECDF    F^\^(x)')
grid on
legend('uniform DF','human', 'chimp')
%legend('uniform DF','human', 'chimp', 'mouse')
title('Nonparametric estimation of species-specific stationary distributions')

%To plot the confidence bands
Alpha=0.05; % set alpha
% compute epsilon_n for first dataset of size 4321
Epsn = sqrt((1/(2*4321))*log(2/Alpha)); 
stairs(x1,max(y1-Epsn,zeros(1,length(y1))),'r','linewidth',1) % lower 1-alpha confidence band
stairs(x1,min(y1+Epsn,ones(1,length(y1))),'r','linewidth',1) % upper 1-alpha confidence band

% compute epsilon_n for first dataset of size 4321
Epsn = sqrt((1/(2*4321))*log(2/Alpha)); 
stairs(x2,max(y2-Epsn,zeros(1,length(y2))),'b','linewidth',1) % lower 1-alpha confidence band
stairs(x2,min(y2+Epsn,ones(1,length(y2))),'b','linewidth',1) % upper 1-alpha confidence band

% compute epsilon_n for first dataset of size 4321
%Epsn = sqrt((1/(2*4321))*log(2/Alpha)); 
%stairs(x3,max(y1-Epsn,zeros(1,length(y3))),'m','linewidth',1) % lower 1-alpha confidence band
%stairs(x3,min(y1+Epsn,ones(1,length(y3))),'m','linewidth',1) % upper 1-alpha confidence band

