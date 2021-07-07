%% Load the data from the comma delimited text file 'NIWACliFloChchAeroClubStationTemps.txt' 
%% with the following column IDs
%% Max_min: Daily Temperature in Christchurch New Zealand
%% Stationate(NZST),Tmax(C),Period(Hrs),Tmin(C),Period(Hrs),Tgmin(C),Period(Hrs),Tmean(C),RHmean(%),Period(Hrs)

% the matrix T is about to be assigned the data as a matrix; the option [27,1,20904,5] to
% specify the upper-left and lower-right corners of an imaginary rectangle
% over the text file 'NIWACliFloChchAeroClubStationTemps.txt'.
% here we start from line number 27 and end at the last line number 20904
% and we read only columns NZST,Tmax(C),Period(Hrs),Tmin(C),Period(Hrs)

T = dlmread('NIWACliFloChchAeroClubStationTemps.txt',',',[27,1,20904,5]); 
% just keep column 1,2 and 4 named NZST,Tmax(C),Period(Hrs),Tmin(C), 
% i.e. date in YYYYMMDD foramt, maximum temperature, minimum temperature
T = T(:,[1,2,4]); % just pull the time
% print size before removing missig data rows are removed
size(T) % report the dimensions or size of the matrix T


% This file has a lot of missing data points and they were replaced with
% NaN values - see the file for various manipulations that were done to the
% raw text file from NIWA (Copyright NIWA 2011 Subject to NIWA's Terms and 
% Conditions.  See: http://cliflo.niwa.co.nz/pls/niwp/doc/terms.html)
T(any(isnan(T),2),:) = [];% Remove any rows containing NaNs from a matrix

size(T) % if the matrix has a different size now then the data-less days now!

clf % clears all current figures

% Daily max and min temperature in the 100 days with good data 
% before last date in this data, i.e, March 27 2011 in Christchurch NZ
figure
H365Days = T(end-365:end,2);
L365Days = T(end-365:end,3);
plot(H365Days,'r*-') % plot daily high or maximum temperature = Tmax
hold on;     % hold the Figure so that we can overlay more plots on it
plot(L365Days,'b*-') % plot daily low or minimum temperature = Tmin
plot(x,H365Days-L365Days, 'g') % plot daily Fluctuation = Tmax - Tmin 
% filter for running means
%data = [1:0.2:4]';
windowSize = 7;
WeeklyHighs = filter(ones(1,windowSize)/windowSize,1,H365Days);
plot(x,WeeklyHighs,'k')
WeeklyLows = filter(ones(1,windowSize)/windowSize,1,L365Days);
plot(x,WeeklyLows,'k')
xlim([0 365]); % set the limits or boundary on the x-axis of the plots 
hold off % turn off holding so we stop overlaying new plots on this Figure

x = [0:365];
figure
xx = linspace(0,365,1000);
Hyy = spline(x, H365Days, xx)
Lyy = spline(x, L365Days, xx)
plot(x, H365Days, 'r*', xx, Hyy, 'r')
xlim([0 365]);
hold on;
plot(x, L365Days, 'b*', xx, Lyy, 'b')


% filter for running means
%data = [1:0.2:4]';
windowSize = 7;
WeeklyHighs = filter(ones(1,windowSize)/windowSize,1,H365Days);
plot(x,WeeklyHighs,'k')
hold off
x = [0:365];
figure
xx = linspace(0,365,1000);
Hyy = spline(x, H365Days, xx)
Lyy = spline(x, L365Days, xx)
plot(x, H365Days, 'r*', xx, Hyy, 'r')
xlim([0 365]);
hold on;
plot(x, L365Days, 'b*', xx, Lyy, 'b')


% filter for running means
%data = [1:0.2:4]';
windowSize = 7;
WeeklyHighs = filter(ones(1,windowSize)/windowSize,1,H365Days);
plot(x,WeeklyHighs,'k')

hold off
