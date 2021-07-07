function p=PdfMultOutcomes(x)
% give a column array p of the probabilties of each possible
% random vector outcome of a multinomial(n,k) 
% Input:       x an array of all the possible outcomes of a multinomial (n,k)
% 	           x will have k columns where k is dimension of the De Moivre random vectors underlying
%               the multinomial, and n is the number of DeMoivre RV's added
%               to give one multinomial RV
k=size(x,2);    % columns of x
n=sum(x(1,:),2);    % sum of any row
theta=ones(1,k)/k;  % the thetas for an equi-probable de Moivre random vector
N=size(x,1); % rows of outcomes in x
p=zeros(N,1);
for i=1:N
    p(i)= MultinomialPdf(x(i,:),n,theta);    % pdf of row i of outcomes
end;
