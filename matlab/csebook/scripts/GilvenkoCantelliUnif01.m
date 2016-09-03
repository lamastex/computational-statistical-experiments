% from Uniform(0,1) RV
rand('twister',76534); % initialize the Uniform(0,1) Sampler
N = 3; % 10^N is the maximum number of samples from Uniform(0,1) RV
u = rand(10,10^N); % generate 10 X 10^N samples from Uniform(0,1) RV U
x=[0:0.001:1];
% plot the ECDF from the first 10 samples using the function ECDF
for i=1:N
    SampleSize=10^i;
    subplot(1,N,i)
    plot(x,x,'r','LineWidth',2); % plot the DF of Uniform(0,1) RV in red
    % Get the x and y coordinates of SampleSize-based ECDF in x1 and y1 and 
    % plot the ECDF using the function ECDF
    for j=1:10

     hold on; 
     if (i==1) [x1 y1] = ECDF(u(j,1:SampleSize),2.5,0.2,0.2); 
     else 
        [x1 y1] = ECDF(u(j,1:SampleSize),0,0.1,0.1);
        stairs(x1,y1,'k');
     end
    end
%     % Note PlotFlag is 1 and the plot range of x-axis is 
%     % incremented by 0.1 or 0.2 on either side due to last 2 parameters to ECDF
%     % being 0.1 or 0.2
%     Alpha=0.05; % set alpha to 5% for instance
%     Epsn = sqrt((1/(2*SampleSize))*log(2/Alpha)); % epsilon_n for the confidence band
     hold on;
%     stairs(x1,max(y1-Epsn,zeros(1,length(y1))),'g'); % lower band plot
%     stairs(x1,min(y1+Epsn,ones(1,length(y1))),'g'); % upper band plot
    axis([-0.1 1.1 -0.1 1.1]);
    %axis square;
    LabelString=['n=' num2str(SampleSize)];
    text(0.75,0.05,LabelString)
    hold off;
end