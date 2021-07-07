function  x = SimdeMoivre(u,f)
% Returns sample(s) from the de Moivre(f=(f_1,f_2,...,f_k)) RV X
% Call Syntax:  x = SimdeMoivre(u,f);
%               deMoivreEqui(u,k);
% Input      : u = array of uniform random numbers eg. rand
%              f = an array of probabilities f=[f1 f2...fk]
% Output     : x = sample(s) from X
n=length(u);
x=zeros(1,n);
for i=1:n
    x(i)=1; % initial index is 1
    current_f=f(x(i));
    while u(i)>current_f;
        x(i)=x(i)+1;
        current_f = current_f + f(x(i));
    end
end