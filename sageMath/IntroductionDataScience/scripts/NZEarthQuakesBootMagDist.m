%% Load the data from the comma delimited text file 'earthquakes.csv' with the following column IDs
% CUSP_ID,LAT,LONG,NZMGE,NZMGN,ORI_YEAR,ORI_MONTH,ORI_DAY,ORI_HOUR,ORI_MINUTE,ORI_SECOND,MAG,DEPTH
EQ=dlmread('earthquakes.csv',','); % the matrix EQ has the data
size(EQ) % report the dimensions or size of the matrix EQ
clf
MaxD=max(datenum(EQ(:,6:11)));
MinD=min(datenum(EQ(:,6:11)));
datestr(MaxD)
datestr(MinD)

LonData=EQ(:,3);
LatData=EQ(:,2);
MagData=EQ(:,12);
subplot(1,3,1)
plot(LonData,LatData,'.') % plot the 3rd column against the 2nd column -- LONGitude Vs. LATtitude
xlabel('Latitude');ylabel('Longitude');
hold on;
%% Faultline as a line between Faultx1x2 and Faulty1y2
FaultLat12=[167+47/60 174.014];% Milford Sound to the northern Port city of S.Island
FaultLon12=[-(44+41/60) -41.283];
SlopeFaultLine=(FaultLon12(2)-FaultLon12(1))/(FaultLat12(2)-FaultLat12(1))
IntcpFaultLine=-136.25
%function Lon = FaultLineFunc(Lat)=SlopeFaultLine*Lat+IntcpFaultLine

line(FaultLat12,FaultLon12,'color','r','LineWidth',2) % fault line

LATS=min(LonData)-1:.1:max(LonData)+1;
plot(LATS,(SlopeFaultLine .* LATS)+IntcpFaultLine,'g.','LineWidth',3)
line(FaultLat12,FaultLon12,'color','r','LineWidth',2) % fault line

Distance=(abs(LatData-((SlopeFaultLine .* LonData)+IntcpFaultLine)))/sqrt(SlopeFaultLine^2+1);
subplot(1,3,2)
plot(MagData,Distance,'.')
xlabel('Magnitude');ylabel('Distance'); 
axis([min(MagData) max(MagData) min(Distance) max(Distance)]);
%hist(Distance)

%% correlation between magnitude and distance
CC=corrcoef(MagData,Distance); % use built-in function to compute sample correlation coefficient matrix
SampleCorrelation=CC(1,2) % plug-in estimate of the correlation coefficient

%% Bootstrap
B = 1000; % Number of Bootstrap replications
BootstrappedCCs=zeros(1,B); % initialise a vector of zeros
N = length(MagData); % sample size
rand('twister',778787671); % initialise the fundamental sampler
for b=1:B
    Indices=ceil(N*rand(N,1));% uniformly sample random indices from 1 to N with replacement
    BootstrappedMag = MagData([Indices]); % bootstrapped Magnitude data
    BootstrappedDis = Distance([Indices]); % bootstrapped Distance data
    CCB=corrcoef(BootstrappedMag,BootstrappedDis); 
    BootstrappedCCs(b)=CCB(1,2); % sample correlation of bootstrapped data
end
%plot the histogram ofBootstrapped Sample Correlations with 15 bins
subplot(1,3,3);hist(BootstrappedCCs,15);xlabel('Bootstrapped Sample Correlations')

% 95% Normal based Confidence Interval
SehatBoot = std(BootstrappedCCs); % std of BootstrappedMedians
% 95% C.I. for median from Normal approximation
ConfInt95BootNormal = [SampleCorrelation-1.96*SehatBoot, SampleCorrelation+1.96*SehatBoot]
% 95% Percentile based Confidence Interval
ConfInt95BootPercentile = ...
    [qthSampleQuantile(0.025,sort(BootstrappedCCs)),...
    qthSampleQuantile(0.975,sort(BootstrappedCCs))]
