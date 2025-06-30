#%% Andra uppgiften

import numpy as np
from scipy.stats.distributions import chi2
from scipy.stats import Normal

# Dela in reella linjen i celler
K = 10
xk = [Normal().icdf((k+1)/K) for k in range(K)]

alpha = 0.05
c = chi2.ppf(1 - alpha, df=K-1) # Kritiskt värde


def simulate(N, mu=0, sigma=1):
    """Simulera N st datapunkter av en normalfördelning med medelvärde mu och standardavvikelse sigma."""
    simulated = np.random.normal(mu, sigma, N)

    Nk=np.zeros(K) # Antalet observationer i varje cell
    for x in simulated:
        for k in range(len(xk)):
            if x < xk[k]:
                Nk[k] += 1
                break
    return Nk


def run(N, mu=0, sigma=1, num_tries=1000):
    Ek = N / K  # Väntevärde av antal observationer i varje cell
    
    # Simulera n ggr
    deviations = 0 # Antalet försök som avviker
    for i in range(num_tries):
        Nk = simulate(N, mu)
        # Beräkna avvikelsen
        T = sum((Nk-Ek)**2 / Ek)
        if T >= c:
            deviations+=1
    
    print(f"Med data simulerad enligt en N({mu}, {sigma**2})-fördelning med N={N} får vi T > c för {100*deviations/num_tries}% av försöken.")


run(10, mu=0)
run(100, mu=0)
run(1000, mu=0)
run(5000, mu=0)

run(10, mu=0.1)
run(100, mu=0.1)
run(200, mu=0.1)
run(1000, mu=0.1)
run(5000, mu=0.1)

