% histogram.m
% Plots density histogram for data in X.
%
% Usage: histogram(X,plotdata,bounds,colour);
%
% Input: X = row vector of data,
%        plotdata (binary) = plot data points?
%        bounds = [lower bound , upper bound] for possible X values,
%        colour (single-character string) = colour of histogram (default =
%        'y' for yellow),
%        bwmethod (optional, default = 2) = method of computing bin width:
%                 0 = Scott's normal reference rule,
%                 1 = Wand's one-stage rule,
%                 2 = Wand's two-stage rule,
%                 3 = manual,
%        bw = manual bin width if bwmethod = 3.
%
% Remark: Bin origin determined by centering the histogram, ie. so that 
% left and right bin edges extend beyond min(X) and max(X) respectively 
% by equal amounts.
%
% Reference: Wand M.P. (1997), "Data-based choice of histogram bin width", 
% American Statistician 51, 59-64.

  function [P,bw] = histogram(X,plotdata,bounds,colour,bwmethod,bw)

  n = length(X); Y = zeros(1,n);

% Determine bin width:

  n3 = n^(-1/3); n5 = n^(-.2); n7 = n^(-1/7);

  Xsort = sort(X); xiq = Xsort(ceil(.75 * n)) - Xsort(ceil(.25 * n));
  sdx = std(X);
  if xiq == 0, sigma = sdx;
  else,        sigma = min([sdx (xiq / 1.349)]); end

  if nargin == 3, bwmethod = 2; colour = 'y'; end
  if nargin == 4, bwmethod = 2; end

  if bwmethod == 0, bw = 3.4908 * sigma * n3;
  elseif bwmethod == 1
        g11 = 1.3041 * sigma * n5;
        bw  = 1.8171 * ((-psi(X,g11,2))^(-1/3)) * n3;
  elseif bwmethod == 2
        g22 = 1.2407 * sigma * n7;
        g21 = 0.9558 * ((psi(X,g22,4))^(-.2)) * n5;
        bw  = 1.8171 * ((-psi(X,g21,2))^(-1/3)) * n3;
  end

% Determine bin origin:

  xmin = min(X); xmax = max(X);
  xrange = max(X) - xmin;
  nbin = ceil(xrange / bw);
  xoffset = (nbin * bw - xrange) / 2;
  bbeg = max(bounds(1),xmin - xoffset); bend = min(bounds(2),xmax + xoffset);
  bw = (bend - bbeg) / nbin;
  BE = bbeg + bw * [0:nbin];

% Count frequencies:

  for i = 1:nbin, P(i) = sum(X >= BE(i) & X < BE(i+1)); end
  P = P / (n * bw);

% Plot histogram:

  YY = [0 1 1 0]' * P; YY = YY(:);
  XX = [1 1 0 0]' * BE(1:nbin) + [0 0 1 1]' * BE(2:(nbin+1)); XX = XX(:);

  if plotdata
     plot(XX,YY,colour,X,Y,[colour '.']), grid
  else
     plot(XX,YY,colour), grid
  end
  xlabel('support'), ylabel('density')

% Function: psi
% Required by histogram.m, kernel.m, sj91.m
%
% Reference: Wand M.P. (1997), "Data-based choice of histogram bin width", 
% American Statistician 51, 59-64: Equations (2.2), (4.1)-(4.4).

  function p = psi(X,g,r)

  n = length(X); c = (n^(-2)) * (g^(-r-1));

  if n < 1000
  
     In = ones(1,n);

     XX = X' * In - In' * X; XX = XX(:) / g; XX2 = XX .* XX;
     Phi = gaussian(XX,1);
  
     if     r == 2
         p = c * (XX2 - 1)' * Phi;
     elseif r == 4
         XX4 = XX2 .* XX2;
         p = c * (XX4 - 6 * XX2 + 3)' * Phi;
     elseif r == 6
         XX4 = XX2 .* XX2; XX6 = XX4 .* XX2;
         p = c * (XX6 - 15 * XX4 + 45 * XX2 - 15)' * Phi;
     else
         disp('Error: Input r for Function PSI must be 2, 4 or 6.'), return
     end
     
  else
  
     xmin = min(X); m = 500; d = (max(X) - xmin) / (m - 1);
     Im = ones(1,m); J = [1:m]; X = X - xmin; On = zeros(1,n);

     for j = 1:m, C(j) = sum(max([(1 - abs((X / d) - j + 1));On])); end

     CC = C' * C;
     JJ = J' * Im - Im' * J; JJ = d * JJ(:) / g; JJ2 = JJ .* JJ;
     CPhi = CC(:) .* gaussian(JJ,1);
  
     if     r == 2
         p = c * (JJ2 - 1)' * CPhi;
     elseif r == 4
         JJ4 = JJ2 .* JJ2;
         p = c * (JJ4 - 6 * JJ2 + 3)' * CPhi;
     elseif r == 6
         JJ4 = JJ2 .* JJ2; JJ6 = JJ4 .* JJ2;
         p = c * (JJ6 - 15 * JJ4 + 45 * JJ2 - 15)' * CPhi;
     else
         disp('Error: Input r for Function PSI must be 2, 4 or 6.'), return
     end
     
  end
  
% Function: gaussian
% Gaussian probability density function.
% Generates normal probability density values corresponding to X.
% Inputs: X = Row vector of support points for which normal density values
%             are required,
%         S = Row vector of standard deviations.
% Output: NPD = Row vector of normal probability density values.

  function NPD = gaussian(X,S)
  
  NPD = exp(-(X .* X) ./ (2 * S .* S)) ./ (sqrt(2 * pi) * S);