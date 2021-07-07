%
% Plot of the abs error and rel error for Cesaro's Bell integral
%
TableQ=[];
TableQL=[];
% The exact values of B_n computed using a recursion
Bn=[1, 2, 5, 15, 52, 203, 877, 4140, 21147, 115975, 678570, 4213597, 27644437, ...
    190899322, 1382958545, 10480142147, 82864869804, 682076806159, 5832742205057, ...
    51724158235372, 474869816156751, 4506715738447323];
% the array of n's in the array of B_n's of interest
ns = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]; 
% the array of N's, N = Number of sub-intervals in QuadMR(a,b,N,g)
Ns=[1 2 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9 2^10 2^11 2^12 2^13 2^14 2^15]; 
% next we use the built-in quadratures of MATLAB (quad and quadl) 
% for details on these quadratures type 'help quad' and 'help quadl'
disp('Approximation of B_n using recursive adaptive Simpson quadrature via quad :');  
disp('------------------------------------------------------------------------------')
disp('                         n       Number of function calls       Approximation')
disp('                        ---      ------------------------       -------------')
for j = 1:length(ns) %columns
 [B20Quad NumberOfFunctCallsInQuad] = quad(@(x)BellIntegrand(x,ns(j)),0,pi);% call quad
 % call QuadMR with same number of function calls as quad just used
 QMR = QuadMR(0,pi,NumberOfFunctCallsInQuad,@(x)BellIntegrand(x,ns(j)));
 oneRow = [ns(j) NumberOfFunctCallsInQuad B20Quad abs(B20Quad-Bn(j))/Bn(j) ...
           QMR abs(QMR-Bn(j))/Bn(j)];
 TableQ = [TableQ;  oneRow;];
end
disp(TableQ)

disp('Approximation of B_n using high order recursive adaptive quadrature via quadl :');
disp('------------------------------------------------------------------------------')
disp('                         n       Number of function calls       Approximation')
disp('                        ---      ------------------------       -------------')
for j = 1:length(ns) %columns
 [B20QuadL NumberOfFunctCallsInQuadL] = quadl(@(x)BellIntegrand(x,ns(j)),0,pi);% call quadl
 % call QuadMR with same number of function calls as quadl just used
 QMR = QuadMR(0,pi,NumberOfFunctCallsInQuadL,@(x)BellIntegrand(x,ns(j)));
 oneRow = [ns(j) NumberOfFunctCallsInQuadL B20QuadL abs(B20QuadL-Bn(j))/Bn(j) ...
           QMR abs(QMR-Bn(j))/Bn(j)];
 TableQL = [TableQL;  oneRow;];
end
disp(TableQL)

semilogy(TableQ(:,1),TableQ(:,4),'r-o')
hold
semilogy(TableQ(:,1),TableQ(:,6)+ 1e-18,'b:o')
semilogy(TableQ(:,1),TableQ(:,2),'g--o')

semilogy(TableQL(:,1),TableQL(:,4),'r-*')
semilogy(TableQL(:,1),TableQL(:,6) + 1e-18,'b:*')
semilogy(TableQL(:,1),TableQL(:,2),'g--*')
axis([0 20 1e-17 1e+5])
legend('Er_{rel} of B_n by quad', 'Er_{rel} of B_n by QuadMR_1', ...
    'Fnct Calls to quad and QuadMR_1','Er_{rel} of B_n by quadl', ...
    'Er_{rel} of B_n by QuadMR_2', 'Fnct Calls to quadl and QuadMR_2')
xlabel('n in n-th Bell number B_n')