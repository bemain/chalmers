

#%% Andra uppgiften

import numpy as np
from scipy.stats.distributions import chi2
from scipy.stats import Normal

K = 10
xks = [Normal().icdf((k+1)/K) for k in range(K)]
print(xks)


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

def run(n=1000, N=100, my=0):
    # Bestäm väntevärde
    Ek = N / K  # = N (F(xk) - F(xk-1)) = N(k/K + (k-1)/K) = N/K
    
    k = 0
    for i in range(n):
        Nk = simulate(my)
        # Beräkna avvikelsen
        T = sum((Nk-Ek)**2 / Ek)
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



#%% Tredje uppgiften
import numpy as np
from scipy.stats.distributions import chi2
from scipy.stats import Normal

my = 100
sigma = 10

K = 10
xks = [Normal().icdf((k+1)/K) for k in range(K)]


def simulate(N):
    xi = np.random.normal(my, sigma, N)

    my_hat = sum(xi) / float(N)
    sigma_hat = np.sqrt(sum((xi - my_hat)**2) / float(N))

    zi = (xi - my_hat) / sigma_hat

    Nk=np.zeros(K)
    for x in zi:
        for k in range(len(xks)):
            if x < xks[k]:
                Nk[k] += 1
                break
    return Nk


alpha = 0.05
c = chi2.ppf(1 - alpha, df=K-3)

def run(N=100, n=1000):
    # Bestäm väntevärde
    Ek = N / K  # = N (F(xk) - F(xk-1)) = N(k/K + (k-1)/K) = N/K
    
    k = 0
    for i in range(n):
        Nk = simulate(N)
        # Beräkna avvikelsen
        T = sum((Nk-Ek)**2 / Ek)
        if T >= c:
            k+=1
    print(f"N({my}, {sigma}^2)-fördelning: T => c för {100*k/n}% av försöken (totalt {n} försök)  då N={N}")


run(10)
run(100)
run(1000)
run(10000)