% Plot the PDF and CDF for Uniform[0,1] RV
x = -1:0.01:2; % vector from -1 to 2; w/ increment .05
% get the [0,1] uniform pdf values of x in vector pdf
pdf = unif01pdf(x);
% get the [0,1] uniform DF or cdf of x in vector cdf
cdf = unif01cdf(x);
% do the plots
% subplot for pdf: subplot(1,2,1) means there is 1 row with 
% 2 columns of subplots and here is the first of them
subplot(1,2,1), plot(x,pdf)
title('Uniform [0,1] pdf')       % title as a string
xlabel('x'), ylabel('f(x)')      % x and y axes labels
axis([-0.2 1.2 -0.2 1.2])   % range specs for x and y axes
axis square                      % axes scaled as square
% subplot for cdf: subplot(1,2,1) means there is 1 row with 
% 2 columns of subplots and here is the first of them
subplot(1,2,2), plot(x,cdf)
title('Uniform [0,1] DF or CDF')
xlabel('x'), ylabel('F(x)')
axis([-0.2 1.2 -0.2 1.2])
axis square