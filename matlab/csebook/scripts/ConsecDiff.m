function y = ConsecDiff(x)
y=zeros(1,length(x));% initialise a vector of zeros
y(2:length(x))=x(2:length(x))-x(1:length(x)-1);