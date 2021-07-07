%% The columns in earthquakes.csv file have the following headings
%%CUSP_ID,LAT,LONG,NZMGE,NZMGN,ORI_YEAR,ORI_MONTH,ORI_DAY,ORI_HOUR,ORI_MINUTE,ORI_SECOND,MAG,DEPTH
EQ=dlmread('earthquakes.csv',','); % load the data in the matrix EQ
size(EQ) % report thr size of the matrix EQ

% Read help datenum -- converts time stamps into numbers in units of days
MaxD=max(datenum(EQ(:,6:11)));% maximum datenum
MinD=min(datenum(EQ(:,6:11)));% minimum datenum
disp('Earth Quakes in NZ between')
disp(strcat(datestr(MinD),' and ',datestr(MaxD)))% print MaxD and MinD as a date string

% get an array of sorted time stamps of EQ events starting at 0
Times=sort(datenum(EQ(:,6:11))-MinD);
TimeDiff=diff(Times); % inter-EQ times = times between successtive EQ events
clf % clear any current figures
%figure
%plot(TimeDiff) % plot the inter-EQ times

subplot(1,2,1) % construct a histogram estimate of inter-EQ times
histogram(TimeDiff',1,[min(TimeDiff),max(TimeDiff)],'r',2);
SampleMean=mean(TimeDiff) % find the sample mean
% the MLE of LambdaStar if inter-EQ times are IID Exponential(LambdaStar)
MLELambdaHat=1/SampleMean 
hold on;
TIMES=linspace(0,max(TimeDiff),100);
plot(TIMES,MLELambdaHat*exp(-MLELambdaHat*TIMES),'b.-')
axis([0 0.5 0 30])
xlabel('Inter-EQ times in days'); ylabel('PDF'); 

%% data 
x=TimeDiff(1:1000);
Epsilon=1;% fixed parameter
%ShiryaevSOEPdf(x,Alpha, Lambda, Epsilon);
% log likelihood function 
%  aXtoL = a * (x .^ b);
%  NorConst=(a^(1/b))/gamma(1+1/b);
%  y = NorConst * exp (-aXtoL) .* (1.0 + (c * sin (aXtoL * tan (b * pi))));
  
lambda=linspace(0.3,.499990,200);
alpha=linspace(0.001, 1,200);
[LAMBDA, ALPHA]=meshgrid(lambda,alpha);
LAMBDA3=repmat(LAMBDA,[1 1 length(x)]);
ALPHA3=repmat(ALPHA,[1 1 length(x)]);

xx=zeros([1 1 length(x)]);xx(:)=x;
x3=repmat(xx,[length(lambda) length(alpha) 1]);
%l = -sum(log((1 ./ (sqrt(2*pi)*zeta) .* x) .* exp((-1/(2*zeta^2))*(log(x)-lambda).^2)));
% LOGLKL = sum(log((1 ./ (sqrt(2*pi)*ZETA3) .* x3) .* exp((-1/(2*ZETA3.^2)).*(log(x3)-LAMBDA3).^2)),3);
aXtoL = ALPHA3 .* (x3 .^ LAMBDA3);
NorConst = 1.0;%(ALPHA3 .^ (1 ./ LAMBDA3)) ./ gamma(1 + (1 ./ LAMBDA3));
LOGLKL = sum(log( NorConst .* exp (-aXtoL) .* (1.0 + (Epsilon * sin (aXtoL .* tan (LAMBDA3 * pi))))),3);
LOGLKL(LOGLKL<0)=NaN;

caxis([0 0.1]*10^3);colorbar
%axis([0 15 0 2 0 0.1*10^3])
clf; meshc(LAMBDA, ALPHA, LOGLKL);
rotate3d on;
