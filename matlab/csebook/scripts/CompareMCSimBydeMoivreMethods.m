format compact
P=[1/3 2/3;1/4 4/5]
initial = 2
visited = [initial];
n = 12;

s = RandStream('mt19937ar','Seed', 5489);
RandStream.setDefaultStream(s) % reset the PRNG to default state Mersenne Twister with seed=5489

VisitByMethod1 = MCSimBydeMoivre(initial, P, n)

s = RandStream('mt19937ar','Seed', 5489);
RandStream.setDefaultStream(s) % reset the PRNG to default state Mersenne Twister with seed=5489

VisitByMethod2 = MCSimBydeMoivreRecurse(visited, P, n)