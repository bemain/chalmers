#%% Tredje uppgiften

import numpy as np
from scipy import stats
from scipy.stats import Normal, chisquare
from scipy.stats.distributions import chi2


mu = 100
sigma = 10

K = 10
zk = [Normal().icdf((k+1)/K) for k in range(K)]


def simulate(N):
    """Simulera N st data-samples av en normalfördelning."""
    xi = np.random.normal(loc=mu, scale=sigma, size=N)

    my_hat = sum(xi) / N
    sigma_hat = np.sqrt(sum((xi - my_hat)**2) / (N - 1))


    zi_hat = (xi - my_hat) / sigma_hat

    # Dela in datan i partitioner
    Nk=np.zeros(K)
    for z in zi_hat:
        for k in range(len(zk)):
            if z < zk[k]:
                Nk[k] += 1
                break
    return Nk


alpha = 0.05
c = chi2.ppf(1 - alpha, df=K-3)


def chi2gof(data, alpha=0.05, nbins=10, ddof=0):
    """
    Performs a chi-squared goodness-of-fit test in Python, similar to MATLAB's chi2gof.

    Args:
        data (array-like): Observed data.
        alpha (float, optional): Significance level. Defaults to 0.05.
        nbins (int, optional): Number of bins to use for the chi-squared test.
        ddof (int, optional): Degrees of freedom to subtract from the chi-squared
            statistic. This is typically the number of estimated parameters of the
            distribution. Defaults to 0.

    Returns:
        tuple: A tuple containing:
            - h (int): 0 if the null hypothesis (data comes from the normal
              distribution) cannot be rejected, 1 if it can be rejected.
            - p (float): The p-value of the chi-squared test.
            - stats (dict): A dictionary containing the chi-squared statistic ('chi2'),
              the degrees of freedom ('df'), and the observed and expected
              frequencies ('observed_freq', 'expected_freq').
    """
    data = np.asarray(data)
    N = len(data)

    
    observed_freq, bin_edges = np.histogram(data, bins=nbins)

    my_hat = sum(data) / N
    sigma_hat = np.sqrt(sum((data - my_hat)**2) / N)
    
    expected_freq = np.diff(stats.norm.cdf(bin_edges, loc=my_hat, scale=sigma_hat)) * N

    chi2 = np.sum((observed_freq - expected_freq)**2 / expected_freq)
    df = nbins - 1 - ddof
    p = 1 - stats.chi2.cdf(chi2, df)

    h = 1 if p < alpha else 0

    stats_dict = {'chi2': chi2, 'df': df,
                  'observed_freq': observed_freq, 'expected_freq': expected_freq}

    return h, p, stats_dict



def run(N, n=10000):
    # Bestäm väntevärde
    Ek = N / K
    
    # Simulera n ggr
    k = 0
    for _ in range(n):
        Nk = simulate(N)
        T = sum((Nk-Ek)**2 / Ek)
        #T, p = chisquare(Nk, f_exp=np.full(K, Ek), ddof=2) # Av nån anledning får vi bättre precision om ddof=0...
        # Beräkna avvikelsen
        if T >= c:
            k+=1
    print(f"N({mu}, {sigma}^2)-fördelning: T > c för {100*k/n}% av försöken (totalt {n} försök)  då N={N}")



run(10)
run(100)
run(1000)
run(5000)


#%%
import numpy as np
from scipy import stats

def simulate_and_test_normality(N, num_simulations=1000, alpha=0.05, num_bins=10):
    """
    Simulerar normalfördelad data, skattar μ och σ², och utför ett chi-två
    goodness-of-fit-test med justerade frihetsgrader.

    Args:
        N (int): Antal observationer i varje simulering.
        num_simulations (int): Antal simuleringar att utföra.
        alpha (float): Signifikansnivå.
        num_bins (int): Antal bins för chi-två-testet.

    Returns:
        float: Andelen gånger som det chi-två-statistikvärdet överskrider
               det kritiska värdet.
    """
    exceed_critical_value_count = 0
    degrees_of_freedom = num_bins - 1 - 2  # K - 1 - antal skattade parametrar (μ och σ²)

    critical_value = stats.chi2.ppf(1 - alpha, degrees_of_freedom)

    for _ in range(num_simulations):
        # Simulera data från N(100, 10^2)
        data = np.random.normal(loc=100, scale=10, size=N)

        # Skatta μ och σ² med stickprovsmedelvärde och -varians
        mu_hat = np.mean(data)
        sigma_hat = np.std(data, ddof=1)  # Använd stickprovsstandardavvikelse (n-1 i nämnaren)

        # Beräkna observerade frekvenser
        hist, bin_edges = np.histogram(data, bins=num_bins)
        observed_freq = hist

        # Beräkna förväntade frekvenser under den skattade normalfördelningen
        expected_freq = np.diff(stats.norm.cdf(bin_edges, loc=mu_hat, scale=sigma_hat)) * N

        # Utför chi-två-test
        # Filtrera bort bins med förväntad frekvens 0 för att undvika division med noll
        valid_indices = expected_freq > 0
        if np.sum(valid_indices) > 1: # Behöver minst 2 bins för chi2-test
            chi2_statistic = np.sum((observed_freq[valid_indices] - expected_freq[valid_indices])**2 / expected_freq[valid_indices])

            if chi2_statistic >= critical_value:
                exceed_critical_value_count += 1

    proportion_exceeding = exceed_critical_value_count / num_simulations
    return proportion_exceeding

num_simulations = 10000
alpha = 0.05
num_bins = 10
N_values = [20, 50, 100, 500, 1000]

print(f"Utför {num_simulations} simuleringar för olika värden på N med {num_bins} bins och α = {alpha}:")
for N in N_values:
    proportion = simulate_and_test_normality(N, num_simulations, alpha, num_bins)
    print(f"För N = {N}: Andel gånger T ≥ F⁻¹χ²(K-3)(0.95) ≈ {proportion:.4f}")
