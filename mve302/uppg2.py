

#%% Andra uppgiften

import numpy as np
from matplotlib import pyplot as plt
from scipy.stats.distributions import chi2
from scipy.stats import Normal

K = 10
xks = [Normal().icdf((k+1)/K) for k in range(K)]
print(xks)


def simulate(my=0):
    # Simulera normalfördelad data
    simulated = np.random.normal(my, 1, N)

    Nks=[0]*K
    for x in simulated:
        for k in range(len(xks)):
            if x < xks[k]:
                Nks[k] += 1
                break
    return Nks



alpha = 0.05
c = chi2.ppf(1 - alpha, df=K-1)

def run(n=1000, N=100, my=0):
    # Bestäm väntevärde
    Ek = N / K  # = N (F(xk) - F(xk-1)) = N(k/K + (k-1)/K) = N/K
    
    k = 0
    for i in range(n):
        Nks = simulate(my)
        # Beräkna avvikelsen
        T = sum(map(lambda Nk: (Nk-Ek)**2 / Ek, Nks))
        if T >= c:
            k+=1
    return k

n = 1000
N = 1000
k = run(n, N, 0.0)
print(f"N(0, 1)-fördelning: T => c för {100*k/n}% av försöken (totalt {n} försök)")

n = 1000
N = 200
k = run(n, N, 0.1)
print(f"N(0.1, 1)-fördelning: T => c för {100*k/n}% av försöken (totalt {n} försök) då N={N}")

n = 1000
N = 1000
k = run(n, N, 0.1)
print(f"N(0.1, 1)-fördelning: T => c för {100*k/n}% av försöken (totalt {n} försök) då N={N}")


