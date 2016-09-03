function x = SampleNormalByNewRap(u,Mu,SigmaSq)
% Returns a sample from Normal(Mu, SigmaSq)
% Newton-Raphson numerical solution of F(x)=u
% Input: u = vector of random Uniform(0,1) samples
%        Mu = Mean of Normal(Mu, SigmaSq)
%        SigmaSq = Variance of Normal(Mu, SigmaSq)
% Usage: x = SampleNormalByNewRap(u,Mu,SigmaSq)
Epsilon=1e-5; % Tolerance in stopping rule
MaxIter=10000; % Maximum allowed iterations in stopping rule
NumUs=length(u); % length of the the vector u of Uniform(0,1) samples
x=zeros(1,NumUs); % initialize the output vector x as 0's
for j=1:NumUs % loop over the entries in u
    % initialize i, xi, and xii
    i=0;        % Mu is an ideal initial condition since F(x; Mu, SigmaSq)
    xi = Mu;    % is convex when x < Mu and concave when x > Mu and the
                % Newton-Raphson method started at Mu converges
    xii = xi - (NormalCdf(xi,Mu,SigmaSq)-u(j))/NormalPdf(xi,Mu,SigmaSq);
    % Newton-Raphson Iterations
    while (abs(NormalCdf(xii,Mu,SigmaSq)-NormalCdf(xi,Mu,SigmaSq))...
            > Epsilon & i < MaxIter),
        xi = xii;
        xii = xii - (NormalCdf(xii,Mu,SigmaSq)-u(j))/NormalPdf(xii,Mu,SigmaSq);
        i=i+1;
    end
    x(j)=xii; % record the simulated x from the j-th element of u
end