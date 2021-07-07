function x=AddOutcomes(A, j, n, k)
% called as a recursive function from MultOutcomes()
% fills in the sample space of the Multinomial by calling itself 
% inputs :  a 1xk vector A
%           and the column we are now filling j
%           and n the number of trials in the multinomial
%           and k which for an equiprobable multinomial defines theta
%            to that theta(i) = 1/k for each dimension i=1,2 ... k
% 
x=zeros(1,k);
e=zeros(1,k);
e(1,j)=1;
tot=sum(A,2); % the sum of the components of A so far
space = n-tot; % can be zero
if j==k % we are at the end
    A = A+space*e; % how much we can add (can be zero)
    x=A;
end;
if j<k % not at the end
    for t=0:space
        A(1,j)=t;
        %A = A+(t*e);   % add t of the current component vector
        %x = AddOutcomes(A,j+1,n,k); % and pass it along to fill the next column
        x=vertcat(x,AddOutcomes(A,j+1,n,k));
        while sum(x(1,:))==0% sum of first row of x
            T=size(x,1); % rows of x
            x=x(2:T,1:k);
        end;
    end;
end; 







    




