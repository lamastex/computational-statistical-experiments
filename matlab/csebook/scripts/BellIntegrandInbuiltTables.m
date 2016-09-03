
ns = [3 10 20]; % the array of n's in the array of B_n's of interest
% the array of N's, N = Number of sub-intervals in QuadMR(a,b,N,g)
Ns=[1 2 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9 2^10 2^11 2^12 2^13 2^14 2^15]; 
% next we use the built-in quadratures of MATLAB (quad and quadl) 
% for details on these quadratures type 'help quad' and 'help quadl'
disp('Approximation of B_n using recursive adaptive Simpson quadrature via quad :');  
disp('------------------------------------------------------------------------------')
disp('                         n       Number of function calls       Approximation')
disp('                        ---      ------------------------       -------------')
for j = 1:length(ns) %columns
 [B20Quad NumberOfFunctCallsInQuad] = quad(@(x)BellIntegrand(x,ns(j)),0,pi);
 disp([ns(j) NumberOfFunctCallsInQuad B20Quad])
end

disp('Approximation of B_n using high order recursive adaptive quadrature via quadl :');
disp('------------------------------------------------------------------------------')
disp('                         n       Number of function calls       Approximation')
disp('                        ---      ------------------------       -------------')
for j = 1:length(ns) %columns
 [B20QuadL NumberOfFunctCallsInQuadL] = quadl(@(x)BellIntegrand(x,ns(j)),0,pi);
  disp([ns(j) NumberOfFunctCallsInQuadL B20QuadL])
end