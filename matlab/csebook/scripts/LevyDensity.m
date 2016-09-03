function LevyFunVal = LevyDensity(parameters);
X=parameters(1); Y=parameters(2); Temp=1.0;%50.0;
Z1 = (cos((0*X)+1) + 2*cos((1*X)+2) + 3*cos((2*X)+3) + 4*cos((3*X)+4) + 5*cos((4*X)+5));
Z2 = (cos((2*Y)+1) + 2*cos((3*Y)+2) + 3*cos((4*Y)+3) + 4*cos((5*Y)+4) + 5*cos((6*Y)+5));
LevyFunVal = exp(-(Z1 .* Z2 + (X + 1.42513) .^2 + (Y + 0.80032) .^ 2)/Temp);