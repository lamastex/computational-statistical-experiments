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
subplot(1,2,1)
plot(LonData,LatData,'.') % plot the 3rd column against the 2nd column -- LONGitude Vs. LATtitude
hold on;
%% Faultline as a line between Faultx1x2 and Faulty1y2
FaultLat12=[167+47/60 174.014];%[166.103 174.014]
FaultLon12=[-(44+41/60) -41.283];%[-48.136 -41.283];
SlopeFaultLine=(FaultLon12(2)-FaultLon12(1))/(FaultLat12(2)-FaultLat12(1))
IntcpFaultLine=-136.25
%function Lon = FaultLineFunc(Lat)=SlopeFaultLine*Lat+IntcpFaultLine

line(FaultLat12,FaultLon12,'color','r','LineWidth',2) % fault line

LATS=min(LonData)-1:.1:max(LonData)+1;
plot(LATS,(SlopeFaultLine .* LATS)+IntcpFaultLine,'g.','LineWidth',3)
line(FaultLat12,FaultLon12,'color','r','LineWidth',2) % fault line

Distance=(abs(LatData-((SlopeFaultLine .* LonData)+IntcpFaultLine)))/sqrt(SlopeFaultLine^2+1);
subplot(1,2,2)
plot(MagData,Distance,'.')
%hist(Distance)
CC=corrcoef(MagData,Distance); % use built-in function to compute sample correlation coefficient matrix
SampleCorrelation=CC(1,2) % plug-in estimate of the correlation coefficient

% figure
% plot3(EQ(:,3),EQ(:,2),datenum(EQ(:,6:11))-MinD,'.')
% axis([164 182 -48 -34 0 MaxD-MinD])
%
% Times=sort(datenum(EQ(:,6:11))-MinD);
% TimeDiff=diff(Times);
% figure
% plot(TimeDiff)
%
% figure
% histogram(TimeDiff',1,[min(TimeDiff),max(TimeDiff)],'r',2);
%
% figure
% plot3(EQ(:,12),EQ(:,13),datenum(EQ(:,6:11))-MinD,'.')
% xlabel('magnitude');ylabel('depth');zlabel('time')
% SampleCorrCoeffMagDep=corrcoef(EQ(:,12),EQ(:,13))
%
%
% figure
% plot(EQ(:,12),EQ(:,13),'.')
% xlabel('magnitude');ylabel('depth');
% SampleCorrCoeffMagDep=corrcoef(EQ(:,12),EQ(:,13))
