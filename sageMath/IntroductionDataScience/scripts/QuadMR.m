function Imr = QuadMR(a,b,M,g);
%
% midpoint-rectangles quadrature to approximate the
% integral of a continuous function g over [a,b]
%
% Call Syntax:  Imr = QuadMR(a,b,M,g);
%               QuadMR(a,b,M,g);
%
% Input      : a = lower bound
%              b = upper bound
%              M = Number of equi-spaced intervals
%              g = integrand function defined on [a,b]
% Output     : Imr = midpoint-rectangles quadrature
%                    approximation for integral_a^b g(x) dx
%
H = (b-a)/M; % H is the width of each subinterval
mp = linspace(a+H/2, b-H/2, M); % the array of midpoints from the M subintervals
gmp = feval(g,mp); % evaluation of the function g at the midpoints in array mp
Imr = H*sum(gmp);
%RectangleAreas = H*gmp % the area of the rectangles UN/COMMENT CODE IN THIS LINE