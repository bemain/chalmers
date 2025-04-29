#%% Andra uppgiften

import numpy as np
from scipy.stats.distributions import chi2
from scipy.stats import Normal

K = 10
xks = [Normal().icdf((k+1)/K) for k in range(K)]


def simulate(my=0):
    # Simulera normalfördelad data
    simulated = np.random.normal(my, 1, N)

    Nk=np.zeros(K)
    for x in simulated:
        for k in range(len(xks)):
            if x < xks[k]:
                Nk[k] += 1
                break
    return Nk



alpha = 0.05
c = chi2.ppf(1 - alpha, df=K-1)

def run(N=100, my=0, n=1000):
    # Bestäm väntevärde
    Ek = N / K  # = N (F(xk) - F(xk-1)) = N(k/K + (k-1)/K) = N/K
    
    k = 0
    for i in range(n):
        Nk = simulate(my)
        # Beräkna avvikelsen
        T = sum((Nk-Ek)**2 / Ek)
        if T >= c:
            k+=1
    print(f"N(0, 1)-fördelning: T => c för {100*k/n}% av försöken (totalt {n} försök)")


run(1000, 0.0)
run(200, 0.1)
run(1000, 0.1)
