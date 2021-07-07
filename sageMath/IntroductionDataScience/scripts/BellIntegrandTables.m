
ns = [3 10 20]; % the array of n's in the array of B_n's of interest
% the array of M's, M = Number of sub-intervals in QuadMR(a,b,M,g)
Ms=[1 2 2^2 2^3 2^4 2^5 2^6 2^7 2^8 2^9 2^10 2^11 2^12 2^13 2^14 2^15]; 
B10Table =zeros(length(Ms)+1,length(ns)+1); % a matrix of zeros initialized
display(['                   ---------------------------------------------' ...
         '----------------------------------------'])
display(['                    M (1st col.)|                     n = 3, 10, 20 ' ...
         'in B_n   (1st row)'])
display(['                   ---------------------------------------------' ...
         '----------------------------------------'])
for i = 1:length(Ms) % rows
    B10Table(i+1,1)=Ms(i);%store the N's in column 1
    for j = 1:length(ns) %columns
        B10Table(1,j+1)=ns(j);%store the n's in row 1
        B10Table(1+i,1+j)=QuadMR(0,pi,Ns(i),@(x)BellIntegrand(x,ns(j)));
    end
end
disp(B10Table);
display(['                   ---------------------------------------------' ...
         '----------------------------------------'])
     
