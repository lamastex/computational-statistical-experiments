function pdf = unifpdf (x, a, b)
% unifpdf(x,a,b) is the PDF of Uniform(a,b) RV
pdf=zeros(size(x));
indices = find(x>=a & x<=b);
pdf(indices) = 1/(b-a);
