p=0.5; q=0.5; P = [1-p p; q 1-q]; % assume a fair coin and a fair die
mu0 = [1, 0]; % inital state vector since Freddy started in rollopia
for t = 1: 1: 21, mut(t,:) = mu0*P^(t-1); end
t=0:1:20; % vector of time steps t
plot(t,mut(:,1)','b*-')
hold on;
p=0.85; q=0.35; P = [1-p p; q 1-q]; % assume an unfair coin and an unfair die
for t = 1: 1: 21, mut(t,:) = mu0*P^(t-1); end
t=0:1:20; % vector of time steps t
plot(t,mut(:,1)','k.-')
p=0.15; q=0.95; P = [1-p p; q 1-q]; % assume another unfair coin and another unfair die
for t = 1: 1: 21, mut(t,:) = mu0*P^(t-1); end
t=0:1:20; % vector of time steps t
plot(t,mut(:,1)','r+-')
xlabel('time step t'); ylabel('Probability of being in rollopia $P(X_t=r)$')
xlabel('time step t'); ylabel('Probability of being in rollopia P(X_t=r)')
