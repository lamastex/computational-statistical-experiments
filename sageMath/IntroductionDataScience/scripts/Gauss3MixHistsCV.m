clf;
rand('twister',6898962)
randn('state',23121);
A=ceil(3*rand(1,2000));% Mixture Label vector
MuSs=[0 5; 10 2; -10 2]%; 5 2; -5 2]
x=arrayfun(@(i)(MuSs(i,1)+MuSs(i,2)*randn),A);
xgrid=-20:1:20;
pdf=NormalPdf(xgrid,MuSs(1,1),(MuSs(1,2))^2)/3 + NormalPdf(xgrid,MuSs(2,1),(MuSs(2,2))^2)/3 ...
    + NormalPdf(xgrid,MuSs(3,1),(MuSs(3,2))^2)/3;
% Draw the first 500 samples be from Normal(0,25)
%x(1:500)=5*randn(1,500);
% Draw the next 500 samples from Normal(10,1)
%x(501:1000)=10+randn(1,500);
% Draw the next 500 samples from Normal(-10,1)
%x(1001:1500)=-10+randn(1,500);
% shells data
%x=[52 54 60 60 54 47 57 58 61 57 50 60 60 60 62 44 55 58 55 60 59 65 59 63 51 61 62 61 60 61 65 43 59 58 67 56 64 47 64 60 55 58 41 53 61 60 49 48 47 42 50 58 48 59 55 59 50 47 47 33 51 61 61 52 62 64 64 47 58 58 61 50 55 47 39 59 64 63 63 62 64 61 50 62 61 65 62 66 60 59 58 58 60 59 61 55 55 62 51 61 49 52 59 60 66 50 59 64 64 62 60 65 44 58 63 58 54 60 55 56 44 60 52 57 58 61 66 56 59 49 48 69 66 49 72 49 50 59 59 59 66 62 44 49 40 59 55 61 51 62 52 63 39 63 52 62 49 48 65 68 45 63 58 55 56 55 57 34 64 66 54 65 61 56 57 59 58 62 58 40 43 62 59 64 64 65 65 59 64 63 65 62 61 47 59 63 44 43 59 67 64 60 62 64 65 59 55 38 57 61 52 61 61 60 34 62 64 58 39 63 47 55 54 48 60 55 60 65 41 61 59 65 50 54 60 48 51 68 52 51 61 57 49 51 62 63 59 62 54 59 46 64 49 61]; 
n=length(x); % n= sample size
Numbws=300;
LEdge=min(x);
UEdge=max(x);
subplot(3,3,7);
[P bw]=histogram(x,1,[LEdge-1,UEdge+1],'green',0);
hold on; plot(xgrid,pdf);
disp([length(P) bw])
title('Scott`s normal reference rule')
subplot(3,3,8);
[P bw]=histogram(x,1,[LEdge-1,UEdge+1],'red',1);
hold on; plot(xgrid,pdf);
disp([length(P) bw])
title('Wand`s one-stage rule')
subplot(3,3,9);
[P bw]=histogram(x,1,[LEdge-1,UEdge+1],'blue',2);
hold on; plot(xgrid,pdf);
disp([length(P) bw])
title('Wand`s two-stage rule')
CVBinSize=1:1:Numbws;
CVRisk=zeros(1,length(CVBinSize));
CVBinWidths=zeros(1,length(CVBinSize));
for i=1:length(CVBinSize)
    Edges=linspace(LEdge-1,UEdge+1,i+1);% Edges for i bins
    P=histc(x,Edges);
    P=P/n;
    bw=Edges(2)-Edges(1);
    %[P bw]=histogram(x,0,[30,85],'red',3,BinWidths(i));
    CVBinWidths(i) = bw;
    CVRisk(i) = (2/((n-1)*bw)) - (((n+1)/((n-1)*bw)) * sum(P .^ 2));
end
[M I]=min(CVRisk);disp([M I CVBinSize(I) CVBinWidths(I)])
MinBin=5;
subplot(3,3,1)
[P bw]=histogram(x,1,[LEdge-1,UEdge+1],'green',3,3);
hold on; plot(xgrid,pdf);
disp([length(P) bw])
title('Under-smoothed')
subplot(3,3,3)
[P bw]=histogram(x,1,[LEdge-1,UEdge+1],'green',3,0.1);
hold on; plot(xgrid,pdf);
disp([length(P) bw])
title('Over-smoothed')
subplot(3,3,2)
[P bw]=histogram(x,1,[LEdge-1,UEdge+1],'green',3,0.7076);
hold on; plot(xgrid,pdf);
disp([length(P) bw])
title('Optimally-smoothed by CV')
%semilogx(CVBinSize(MinBin:length(CVBinSize)),(CVRisk(MinBin:length(CVBinSize))),'k');
%title('Cross-validation Score Versus Number of Bins')
%hold on;stem(CVBinSize(I),CVRisk(I))
%semilogx(CVBinWidths(MinBin:length(CVBinSize)),(CVRisk(MinBin:length(CVBinSize))),'r.');
%stem(CVBinWidths(I),CVRisk(I))
subplot(3,3,4:6)
plot(CVBinWidths(MinBin:length(CVBinSize)),(CVRisk(MinBin:length(CVBinSize))),'ko-');
axis([0 7 -0.045 -0.03]);
title('Cross-validation Score Versus Bin-width')
hold on;stem(CVBinWidths(I),CVRisk(I))