function x = SimdeMoivreEqui(u,k);
% return samples from de Moivre(1/k,1/k,...,1/k) RV X
% Call Syntax:  x = SimdeMoivreEqui(u,k);
% Input      : u = array of uniform random numbers eg. rand 
%              k = number of equi-probabble outcomes of X
% Output     : x = samples from X
x = ceil(k * u) ; % ceil(y) is the smallest integer larger than y
%x = floor(k * u); if outcomes are in {0,1,...,k-1}