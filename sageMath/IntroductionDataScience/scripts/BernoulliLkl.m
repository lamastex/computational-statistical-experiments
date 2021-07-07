clf
BS=[0 1];
subplot(2,3,1)
theta=0.5;% true theta
ThetaS=[0:0.001:1]; % sample some values for theta

plot(0,0,'r.','MarkerSize',25)
hold on;
plot(0,1,'bo','MarkerSize',8)
set(gca,'XTick',0:0:0)
set(gca,'YTick',0:0:0)
for I=1:2
    text(0.05,0.05+BS(I),strcat(['(',num2str([BS(I)]),')']))%'rotation',90);
end
axis square

subplot(2,3,4);
x=[1]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'b','LineWidth',1); 
hold on; 
plot([1],[0],'bo','MarkerSize',8)
plot([0],[0],'r.','MarkerSize',25)
stem([0 1],BinomialPdf([0 1],1,theta),'k.','MarkerSize',8)
x=[0]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'r','LineWidth',1); 
axis square

subplot(2,3,2)
x=[0 0 1 1];
y=[0 1 0 1];
hold on;
plot(x(3),y(3),'m*','MarkerSize',8)
plot(x(4),y(4),'bo','MarkerSize',8)
plot(x(1),y(1),'r.','MarkerSize',25)
plot(x(2),y(2),'m*','MarkerSize',8)

set(gca,'XTick',0:1:1)
set(gca,'YTick',0:1:1)
for I=1:2
    for J=1:2
        text(0.05+BS(I),0.05+BS(J),strcat(['(',num2str([BS(I),BS(J)]),')']))%'rotation',90);
    end
end
box on;
axis square

subplot(2,3,5);
x=[0 1]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'m','LineWidth',1); 
hold on; 
plot([1],[0],'bo','MarkerSize',8)
plot([0],[0],'r.','MarkerSize',25)
plot([1/2],[0],'m*','MarkerSize',8)
stem([0 1/2 1],BinomialPdf([0 1 2],2,theta),'k.','MarkerSize',8)
x=[0 0]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'r','LineWidth',1); 
hold on; 
x=[1 1]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'b','LineWidth',1); 
axis square

subplot(2,3,3)
x=[0 0 0 0 1 1 1 1];
y=[0 0 1 1 0 0 1 1];
z=[0 1 0 1 0 1 0 1];
plot3(x(1),y(1),z(1),'r.','MarkerSize',30)
hold on;
plot3(x(2:3),y(2:3),z(2:3),'kx','MarkerSize',15)
plot3(x(5),y(5),z(5),'kx','MarkerSize',15)
plot3(x(4),y(4),z(4),'m*','MarkerSize',15)
plot3(x(6:7),y(6:7),z(6:7),'m*','MarkerSize',15)
plot3(x(8),y(8),z(8),'bo','MarkerSize',10)
box on; grid on;
set(gca,'XTick',0:1:1)
set(gca,'YTick',0:1:1)
set(gca,'ZTick',0:1:1)
BS=[0 1];
for I=1:2
    for J=1:2
        for K=1:2
            text(0.1+BS(I),0.05+BS(J),0.1+BS(K),strcat(['(',num2str([BS(I),BS(J),BS(K)]),')']))%'rotation',90);
        end
    end
end
%az=-38.5000; el=28; view(az, el);
axis square

subplot(2,3,6);
x=[0 0 0]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'r','LineWidth',1); 
hold on; 
stem([0 1/3 2/3 1],BinomialPdf([0 1 2 3],3,theta),'k.','MarkerSize',8)
plot([0],[0],'r.','Markersize',25)
plot([1/3],[0],'kx','Markersize',10)
plot([2/3],[0],'mX','Markersize',10)
plot([0],[0],'r.','Markersize',25)
plot([1],[0],'bo','Markersize',10)
x=[0 0 1]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'k','LineWidth',1); 
hold on; 
x=[1 1 0]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'m','LineWidth',1); 
x=[1 1 1]; n=length(x); t = sum(x); l=@(theta)(theta ^ t * (1-theta)^(n-t)); 
plot(ThetaS,arrayfun(l,ThetaS),'b','LineWidth',1); 
axis square