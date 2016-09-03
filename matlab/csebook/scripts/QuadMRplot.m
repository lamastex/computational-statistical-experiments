function Pmr = QuadMRplot(a,b,M,g);
% visualization for midpoint-rectangles quadrature 
% to approximate the integral of a continuous function 
% g over [a,b]
%
% Call Syntax:  Imr = QuadMRplot(a,b,M,g);
%               QuadMRplot(a,b,M,g);
%
% Input      : a = lower bound
%              b = upper bound
%              M = Number of equi-spaced intervals
%              g = integrand function defined on [a,b]
% Output     : Pmr = a graphics handle of midpoint-rectangles quadrature
%                    approximation for integral_a^b g(x) dx
%                    as a plot with rectangles and areas
%
%MyFontSize=12; % set some font size for finer control sometimes
YMaxfudge=0.05; %0.1% a value to control the y-axis range
x=linspace(a,b,1000); % x is array of points in domain for plot of g
y=feval(g,x); % store g(x) in y
Miny=min(0,min(y)); % assuming the minimum of 0 is sensible -- change for negative g
Maxy=max(y)+YMaxfudge; % max value for g(x) from the sampled points in x
Pmr = plot(x,y); % plot of g is stored in Pmr
axis([a b Miny Maxy]); % axis limits

hold on
H = (b-a)/M; % H is the width of each subinterval
mp = linspace(a+H/2, b-H/2, M); % the array of midpoints from the M subintervals
gmp = feval(g,mp); % evaluation of the function g at the midpoints in array mp
Imr = H*sum(gmp); % quadrature Imr = sum of mid-point rectangles

RectangleAreas = H*gmp; % the area of the rectangles 
for i=1:M
    if gmp(i) >= 0
        SouthWestX = mp(i)-H/2; SouthWestY = 0; Height = gmp(i);
    else
        SouthWestX = mp(i)-H/2; SouthWestY = gmp(i); Height = -gmp(i);
    end
    % setting height to some arbitrary low number to to draw rectangles of
    % positive height
    if(Height==0.0) 
        Height=1e-100;
    end
    rectangle('Position',[SouthWestX,SouthWestY,H,Height], ...
              'FaceColor',[0.85 0.85 0.85]);
    text(mp(i),(gmp(i)+0)/2,num2str(RectangleAreas(i)), ...
              'rotation',90);%,'FontSize',MyFontSize);
end
plot(x,y,'LineWidth',1); % replot of g to overlay on rectangles
% the title prints the quadrature Imr
title(['QuadMR = ' num2str(Imr)]);%,'FontSize',MyFontSize); 
hold off
