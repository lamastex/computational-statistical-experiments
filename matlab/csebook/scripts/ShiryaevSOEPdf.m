  function y = ShiryaevSOEPdf(x,a, b, c);
  aXtob = a * (x .^ b);
  NorConst=1.0;%(a^(1/b))/gamma(1+1/b);
  y = NorConst * exp (-aXtob) .* (1.0 + (c * sin (aXtob * tan (b * pi))));