clf
BS=[0 1];
subplot(2,3,1)

plot(0,0,'g.','MarkerSize',25)
hold on;
plot(0,1,'b.','MarkerSize',25)
set(gca,'XTick',0:0:0)
set(gca,'YTick',0:0:0)
for I=1:2
    text(0.05,0.05+BS(I),strcat(['(',num2str([BS(I)]),')']))%'rotation',90);
end
axis square

subplot(2,3,2)
x=[0 0 1 1];
y=[0 1 0 1];
hold on;
plot(x(3),y(3),'b.','MarkerSize',25)
plot(x(4),y(4),'r.','MarkerSize',25)
plot(x(1),y(1),'g.','MarkerSize',25)
plot(x(2),y(2),'b.','MarkerSize',25)

set(gca,'XTick',0:1:1)
set(gca,'YTick',0:1:1)
for I=1:2
    for J=1:2
        text(0.05+BS(I),0.05+BS(J),strcat(['(',num2str([BS(I),BS(J)]),')']))%'rotation',90);
    end
end
axis square

subplot(2,3,3)
x=[0 0 0 0 1 1 1 1];
y=[0 0 1 1 0 0 1 1];
z=[0 1 0 1 0 1 0 1];
plot3(x(1),y(1),z(1),'g.','MarkerSize',30)
hold on;
plot3(x(2:3),y(2:3),z(2:3),'b.','MarkerSize',30)
plot3(x(5),y(5),z(5),'b.','MarkerSize',30)
plot3(x(4),y(4),z(4),'r.','MarkerSize',30)
plot3(x(6:7),y(6:7),z(6:7),'r.','MarkerSize',30)
plot3(x(8),y(8),z(8),'m.','MarkerSize',30)
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
