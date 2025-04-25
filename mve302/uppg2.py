import numpy as np
from matplotlib import pyplot as plt
from scipy.stats.distributions import chi2
from scipy.stats import Normal

K = 10
N = 1000

xks = [Normal().icdf((k+1)/K) for k in range(K)]
print("xk", xks)

# Bestäm väntevärde
Ek = N / K  # = N (F(xk) - F(xk-1)) = N(k/K + (k-1)/K) = N/K
print("Ek", Ek)

alpha = 0.05
c = chi2.ppf(1 - alpha, df=K-1)


def simulate():
    # Simulera normalfördelad data
    simulated = np.random.normal(0, 1, N)

    Nks=[0]*K
    for x in simulated:
        for k in range(len(xks)):
            if x < xks[k]:
                Nks[k] += 1
                break
    
    # Beräkna avvikelsen
    T = sum(map(lambda Nk: (Nk-Ek)**2 / Ek, Nks))
    
    return T


n = 0
for i in range(100):
    if simulate() <= c:
        n+=1
print(n)