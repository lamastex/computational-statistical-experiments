  function y = ShiryaevSOELklc(x,a, b, c);
  aXtoL = a * (x .^ b);
  NorConst=(a^(1/b))/gamma(1+1/b);
  y = sum( log( NorConst * exp (-aXtoL) .* (1.0 + (c * sin (aXtoL * tan (b * pi))))));