function x=MultinomialOutcomes(n, k)
% create a matrix of the sample space assuming equiprobable thetas
% inputs :  n the number of trials in the multinomial
%           and k which for an equiprobable multinomial defines theta
%            to that theta(i) = 1/k for each dimension i=1,2 ... k
% 
A = zeros(1,k); % starting point
y = AddOutcomes(A, 1, n, k); % call function to do the hard work
%cleans up extra rows of zeros which will come back in the 
% A returned by AddOutcomes;
while sum(y(1,:))==0% sum of first row of y
    T=size(y,1); % rows of y
    y=y(2:T,1:k); % take off the top row since it's zeros
end;
x=y; % return the cleaned up y


