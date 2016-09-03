x = linspace(-2*pi,2*pi,100);	 % x has 100 points equally spaced in [-2*pi, 2*pi]
y = sin(x);		% y is the term-wise sin of x, ie sin of every number in x is in y, resp.
plot(x,y,'.');		  % plot x versus y as dots should appear in the Figure window
xlabel('x');		% label x-axis with the single quote enclosed string x
ylabel('sin(x)','FontSize',16);	   % label y-axis with the single quote enclosed string
title('Sine Wave in [-2 pi, 2 pi]','FontSize',16);	% give a title; click Figure window to see changes
set(gca,'XTick',-8:1:8,'FontSize',16) % change the range and size of X-axis ticks
% you can go to the Figure window's File menu to print/save the plot