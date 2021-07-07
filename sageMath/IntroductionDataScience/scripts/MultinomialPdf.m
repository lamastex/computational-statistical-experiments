function MP = MultinomialPdf(x,n,theta)
% returns the multinomial Pdf of x(1),x(2),...,x(k) given
% theta(1),...,theta(k). x and theta are vectors and sum to
% the scalars n and 1, respectively and 0 <= x(i) <= n
% Since double precision numbers only have about 15 digits, the answer is
% only accurate for n <= 21 in factorial function.
NonZeroXs = find(x>0);
MP=exp(log(factorial(n))+sum((log(theta(NonZeroXs)) .* x(NonZeroXs)) ...
    - log(factorial(x(NonZeroXs)))));