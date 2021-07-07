function VisitedStateIdxs = MCSimBydeMoivreRecurse(VisitedStateIdxs, P, n)
% input: VisitedStateIdxs = array of indexes of states visited so far
%        P = transition probability matrix (has to be stochastic matrix)
%        n = number of time steps to simulate, n >= 0
% output: VisitedStateIdxs = idx0, idx1, ..., idxn
i = length(VisitedStateIdxs);
if  i < n
    CurrentState = VisitedStateIdxs(1, i); % current state
    Thetas = P(CurrentState,:);
    % recursion
    VisitedStateIdxs= MCSimBydeMoivreRecurse([VisitedStateIdxs SimdeMoivreOnce(rand,Thetas)],P,n); % next state
   
end
end