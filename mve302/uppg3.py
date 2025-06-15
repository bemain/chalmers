#%% Tredje uppgiften

import numpy as np
from scipy.stats.distributions import chi2
from scipy.stats import Normal, chisquare

my = 100
sigma = 10

K = 10
zk = [Normal().icdf((k+1)/K) for k in range(K)]


def simulate(N):
    xi = np.random.normal(my, sigma, N)

    my_hat = sum(xi) / N
    sigma_hat = np.sqrt(sum((xi - my_hat)**2) / N)


    zi_hat = (xi - my_hat) / sigma_hat

    Nk=np.zeros(K)
    for z in zi_hat:
        for k in range(len(zk)):
            if z < zk[k]:
                Nk[k] += 1
                break
    return Nk


alpha = 0.05
c = chi2.ppf(1 - alpha, df=K-3)

def run(N, n=1000):
    # Bestäm väntevärde
    Ek = N / K
    
    # Simulera n ggr
    k = 0
    for i in range(n):
        Nk = simulate(N)
        T, p = chisquare(Nk, f_exp=np.full(K, Ek))
        # Beräkna avvikelsen
        if T >= c:
            k+=1
    print(f"N({my}, {sigma}^2)-fördelning: T => c för {100*k/n}% av försöken (totalt {n} försök)  då N={N}")


run(100)
run(1000)
run(10000)
