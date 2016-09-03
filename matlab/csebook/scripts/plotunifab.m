function[x, fx, Fx] = plotunifab(a, b, n);
%
% 1. Generate n equi-distanced samples in [a,b] and 
% return the samples x, pdf fx and CDF Fx for the 
% Uniform[a,b] RV.
% 2. Plot the pdf and CDF for Uniform[a,b] RV based 
% on these n samples from a to b
%
% File Dates : Created  07/23/07  Modified  07/23/07
% Author(s)  : Raaz 
%
% Call Syntax: [x pdf Fx] = plotunifab(a, b, n); 
%              or plotunifab(a, b, n);
%
% Input      : a = lower bound, b = upper bound, 
%              n = number of sample points in x 
% Output     : [x fx Fx]
%
FudgeX=(0.1/(b-a));        % plot x fudge factor
FudgeY=(0.1/(b-a));            % plot y fudge factor

x = linspace(a-FudgeX,b+FudgeX,n); % vector from a to b w/ n points
%
% get the [a,b] uniform pdf values of x in vector fx
%
fx = 1/(b-a)*ones(1,length(x));
%
% get the [a,b] uniform DF or cdf of x in vector Fx
%
Fx = [];
for i=1:length(x)
    if x(i)<a Fx=[Fx 0]; 
    elseif x(i)>b Fx=[Fx 1]; 
    else Fx=[Fx (x(i)-a)/(b-a)]; 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do the plots
% subplot for pdf 
% subplot(1,2,1) means there is 1 row with 2 columns 
% of subplots and here is the first of them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,1), plot(x,fx)
% title as a concatenated string with num2str commands 
% that convert the user-specified input numbers a and b 
% to strings for automatic inclusion in title:
%
title(['Uniform [',num2str(a),',',num2str(b),'] pdf'])
xlabel('x'), ylabel('f(x)')      % x and y axes labels
% axes range specifications
axis([(a-FudgeX) (b+FudgeX) (0-FudgeY) (1/(b-a)+FudgeY)]) 
axis square                       % axes scale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot for cdf
% subplot(1,2,1) means there is 1 row with 2 columns 
% of subplots and here is the first of them
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,2), plot(x,Fx)
title(['Uniform [',num2str(a),',',num2str(b),'] DF or CDF'])
xlabel('x'), ylabel('F(x)')
axis([(a-FudgeX) (b+FudgeX) (0-FudgeY) (1+FudgeY)]) 
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u=linspace(0,1,n);
subplot(1,3,3), plot(u,a+(b-a)*u)
title(['Uniform [',num2str(a),',',num2str(b),'] Inverse DF'])
xlabel('u'), ylabel('F inverse (u)')
axis([(0) (1) (a-FudgeX) (b+FudgeX) ]) 
axis square
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
