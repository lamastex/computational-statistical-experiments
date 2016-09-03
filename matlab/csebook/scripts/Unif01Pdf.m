function Pdf = Unif01Pdf (x)
% Unif01Pdf(x) returns the PDF of Uniform(0,1) RV X
% the input x can be an array
Pdf=zeros(size(x)); % Pdf is an array of zeros and of the same size as x
% use the built-in find function to find the Indices of x whose values are in the range [0,1]  
Indices = find(x>=0 & x<=1);
Pdf(Indices) = 1; % Set these indices in array Pdf to 1=PDF of X over [0,1]
