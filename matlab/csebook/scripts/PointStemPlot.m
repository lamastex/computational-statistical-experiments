clf % clear any current figures being displayed
z=[-1.4508 0.6636 -1.4768 -1.2455 -0.8235 1.1254 -0.4093 0.1199 0.2043 -0.8236]
subplot(1,2,1)
plot(z,'o')
axis([0 11 -2 2]) % set the plot x-axis range in [0, 11] and y axis range in [-2 2]
set(gca,'XTick',1:10,'FontSize',16)
set(gca,'YTick',-1.8:0.5:1.8,'FontSize',16)
%axis square
subplot(1,2,2)
stem(z) % make a default stem plot of ordered pairs (1,z(1)), (2,z(2)), ..., (10,z(10))
axis([0 11 -2 2]) % set the plot x-axis range in [0, 11] and y axis range in [-2 2]
%axis square
set(gca,'XTick',1:10,'FontSize',16)
set(gca,'YTick',-1.8:0.5:1.8,'FontSize',16)