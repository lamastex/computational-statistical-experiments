function VisitedStateIdxs = MCSimBydeMoivre(idx0, P, n)
% input: idx0 = index of initial state x_0, psi(idx0) = x_0
%        P = transition probability matrix (has to be stochastic matrix)
%        n = number of time steps to simulate, n >= 0
% output: VisitedStateIdxs = idx0, idx1, ..., idxn
VisitedStateIdxs = zeros(1,n);
VisitedStateIdxs(1, 0+1) = idx0; % initial state index is the input idx0
for i=1:n-1
    CurrentState = VisitedStateIdxs(1, i); % current state
    Thetas = P(CurrentState,:);
    VisitedStateIdxs(1, i+1) = SimdeMoivreOnce(rand,Thetas); % next state
end
end