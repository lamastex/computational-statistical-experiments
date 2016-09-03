% RejectionNormalLaplacian.m
% Generates normal(0,1) random variables using the rejection method with a
% Laplacian distribution.

clear all
clf;

n = 100; % number of random variables to propose

rand('twister',11)

xx=-5:0.05:5;
ff=NormalPdf(xx,0,1); % pdf of target Normal(0,1) RV X
gg=1/2* exp(-abs(xx)); % pdf of proposal Laplace(1) RV Y
aa=sqrt(2/pi) * exp(1/2); % constant a
plot(xx,ff,xx,gg,xx,(ff ./ gg), xx, (aa * gg))

hold on;
U0s=rand(1,n); % samples from Uniform(0,1) variates
Ys=LaplaceInvCDF(U0s,1); % proposals from Y
Us=rand(1,n); % new set of Uniform(0,1) variates
gYsTimesUs = Us .* (aa * 1/2* exp(-abs(Ys))) ;
plot(Ys, gYsTimesUs, 'b o' )

RejYsIndices = find(gYsTimesUs ./ NormalPdf(Ys,0,1)  > 1); % rejected Ys
plot(Ys(RejYsIndices), gYsTimesUs(RejYsIndices), 'r.' )
AccYsIndices = find(gYsTimesUs ./ NormalPdf(Ys,0,1)  <= 1);% accepted Ys
NumberAccepted=size(AccYsIndices,2);
plot(Ys(AccYsIndices), zeros(1,NumberAccepted), 'b+' )
legend('f = PDF Normal(0,1)', 'g = PDF Laplace(1)', 'f/g', 'a g', '(y, u a g(y))','rejected','accepted')
%histogram(Ys(AccYsIndices),0,[-inf inf],'r'); grid off
% NumBins=10;
% [Fs,Cs]=hist(Ys(AccYsIndices),NumBins)
% BinSize=(max(Ys(AccYsIndices))-min(Ys(AccYsIndices))) / NumBins;
% sum(Fs/(BinSize*NumberAccepted) .* ones(1,NumBins)*BinSize)
% bar(Cs,Fs/(BinSize*NumberAccepted),1)