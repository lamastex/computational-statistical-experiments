clf;
%x=randn(1,100);%
%x=ShuttleTemps; % data
%x=randn(1,100000);
%load WebLogTimes20071001035730.dat % read data from first file
% multiply day (October 1) by 24*60*60 seconds, hour by 60*60 seconds, 
% minute by 60 seconds and seconds by 1, to rescale time in units of seconds
%SecondsScale1 = [24*60*60; 60*60; 60; 1;]; 
%StartTime1 = [1 3 57 30] * SecondsScale1; % find start time in seconds scale
%now convert time in Day/Hours/Minutes/Seconds format to seconds scale from
%the start time 
%WebLogSeconds20071001035730 = WebLogTimes20071001035730 * SecondsScale1 - StartTime1;
%x=ConsecDiff(sort(WebLogSeconds20071001035730));
%x=sort(WebLogSeconds20071001035730);
%x=x';
%x=x/(60*60);
randn('state',23121);
x(1:1000)=5*randn(1,1000);x(1001:2000)=10+randn(1,1000);x(2001:3000)=-10+randn(1,1000);
%x=[52 54 60 60 54 47 57 58 61 57 50 60 60 60 62 44 55 58 55 60 59 65 59 63 51 61 62 61 60 61 65 43 59 58 67 56 64 47 64 60 55 58 41 53 61 60 49 48 47 42 50 58 48 59 55 59 50 47 47 33 51 61 61 52 62 64 64 47 58 58 61 50 55 47 39 59 64 63 63 62 64 61 50 62 61 65 62 66 60 59 58 58 60 59 61 55 55 62 51 61 49 52 59 60 66 50 59 64 64 62 60 65 44 58 63 58 54 60 55 56 44 60 52 57 58 61 66 56 59 49 48 69 66 49 72 49 50 59 59 59 66 62 44 49 40 59 55 61 51 62 52 63 39 63 52 62 49 48 65 68 45 63 58 55 56 55 57 34 64 66 54 65 61 56 57 59 58 62 58 40 43 62 59 64 64 65 65 59 64 63 65 62 61 47 59 63 44 43 59 67 64 60 62 64 65 59 55 38 57 61 52 61 61 60 34 62 64 58 39 63 47 55 54 48 60 55 60 65 41 61 59 65 50 54 60 48 51 68 52 51 61 57 49 51 62 63 59 62 54 59 46 64 49 61]; 
n=length(x); % n= sample size
Numbws=250;
LEdge=min(x);
UEdge=max(x);
subplot(1,2,1);
[P bw]=histogram(x,1,[min(x)-1,max(x)+1],'green',0);
disp([length(P) bw])
hold on;
[P bw]=histogram(x,1,[min(x)-1,max(x)+1],'red',1);
disp([length(P) bw])
[P bw]=histogram(x,1,[min(x)-1,max(x)+1],'blue',2);
disp([length(P) bw])
%CVRiskBW = zeros(2,Numbws);
%BinWidths=linspace(1,30,Numbws)
CVBinSize=1:1:Numbws;
CVRisk=zeros(1,length(CVBinSize));
for i=1:length(CVBinSize)
    Edges=linspace(LEdge-1,UEdge+1,i+1);% Edges for i bins
    P=histc(x,Edges);
    P=P/n;
    bw=Edges(2)-Edges(1);
    %[P bw]=histogram(x,0,[30,85],'red',3,BinWidths(i));
    %CVRiskBW(1,i) = length(P);
    %CVRiskBW(2,i) = (2/((n-1)*bw)) - (((n+1)/((n-1)*bw) * sum((P*bw) .^ 2)));
    CVRisk(i) = (2/((n-1)*bw)) - (((n+1)/((n-1)*bw)) * sum(P .^ 2));
end
MinBin=50;
subplot(1,2,2)
%plot(CVRiskBW(1,MinBin:Numbws),(CVRiskBW(2,MinBin:Numbws)))
plot(CVBinSize(MinBin:length(CVBinSize)),(CVRisk(MinBin:length(CVBinSize))));
[M I]=min(CVRisk);
disp([M I CVBinSize(I)])