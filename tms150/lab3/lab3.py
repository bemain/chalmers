#%% Setup (used throughout)
import random
import numpy as np
import matplotlib.pyplot as plt


def f(x): return x**4  # Defined on [0,1] -> [0,1]

theta = 1/5 # Analytical (actual) value of the integral




#%% Question 1 - Crude MC
count = 0
M = 1000000 # Sample size
for k in range(M):
    U = random.random() # Random number in [0,1)
    count += f(U)
print(count / M) # The estimate




#%% Question 2 - Hit-or-miss MC
count = 0
M = 1000000 # Sample size
for k in range(M):
    U1, U2 = random.random(), random.random() # Random numbers in [0,1)
    if U2 <= f(U1):
        count += 1
print(count / M) # The estimate




#%% Question 3

# Compute "standard" error
K = 20
sample_sizes = [2**i for i in range(1, K+1)]
M = sample_sizes[-1]

def compute_errors():
    """ 
    Perform two types of MC estimates (crude and hit-or-miss) and return 
    the errors of the estimates, computed using the analytic value [theta]. 
    """
    count_mc, count_hm = 0, 0
    error_mc, error_hm = np.zeros(K), np.zeros(K)
    for m in range(1, M+1):
        # Increase counts
        U1, U2 = random.random(), random.random() # Random numbers in [0,1)
        count_mc += f(U1)
        if U2 <= f(U1):
            count_hm += 1
        
        if m in sample_sizes:
            # Calculate errors
            i = sample_sizes.index(m)
            error_mc[i] = np.abs(count_mc / m - theta)
            error_hm[i] = np.abs(count_hm / m - theta)

    return error_mc, error_hm


error_mc, error_hm = compute_errors()

plt.figure()
plt.title(r"Errors of our MC estimates")
plt.xlabel(r"$M$")
plt.ylabel("Error")
plt.loglog(sample_sizes, error_mc, marker='o', color="blue", label="Crude MC")
plt.loglog(sample_sizes, error_hm, marker='o', color="green", label="Hit-or-miss MC")
plt.loglog(sample_sizes, 1 / np.sqrt(sample_sizes), color="orange", label=r"Reference slope $M^{-1/2}$")

plt.legend()

plt.savefig("3-errors.pdf")


# Compute root mean squared errors
def compute_root_mean_squared_errors(N=10):
    """ 
    Estimate the root mean squared error using another MC estimate, for 
    two types of MC estimates (crude and hit-or-miss).
    """
    count_mc, count_hm = np.zeros(K), np.zeros(K)
    for _ in range(N):
        error_mc, error_hm = compute_errors()
        count_mc += error_mc ** 2
        count_hm += error_hm ** 2
    return np.sqrt(count_mc / N), np.sqrt(count_hm / N)


# Compute root mean squared errors for different values of N
for N in [5, 10, 50]:
    rmse_mc, rmse_hm = compute_root_mean_squared_errors(N)

    plt.figure()
    plt.title(fr"Root mean squared errors with $N={N}$")
    plt.xlabel(r"$M$")
    plt.ylabel("Root mean square error")
    plt.loglog(sample_sizes, rmse_mc, marker='o', color="blue", label="Crude MC")
    plt.loglog(sample_sizes, rmse_hm, marker='o', color="green", label="Hit-or-miss MC")
    plt.loglog(sample_sizes, 1 / np.sqrt(sample_sizes), color="orange", label=r"Reference slope $M^{-1/2}$")
    plt.legend()
    plt.savefig(f"3-rmse-N={N}.pdf")




#%% Question 4
resolutions = [2**(-i) for i in range(1,11)] # N_i

# We simulate only the highest resolution, and then use that to compute 
# the sample paths for lower resolutions, as described in the report.
maxH = resolutions[-1]
maxN = int(1/maxH)
etas = np.random.normal(0, np.sqrt(maxH), maxN)

T = 1

def brownian(h: float, etas):
    """
    Simulate a Brownian motion at resolution h, 
    using the random numbers etas.
    """
    N = int(1/h)
    scale = int(h/maxH)

    W = 0
    Ws = np.zeros(N+1)
    # Recursive algorithm
    for n in range(1,N+1):
        eta = np.sum(etas[n*scale : (n+1)*scale])
        W += eta
        Ws[n] = W
    return Ws

plt.figure()
plt.title(fr"Sample path of a Brownian motion")
plt.xlabel(r"$t$")
plt.ylabel("$W(t)$")

for h in resolutions:
    N = int(1/h)
    W = brownian(h, etas)
    
    i = int(np.log(N)/np.log(2))
    plt.plot(np.linspace(0, T, num=N+1), 
             W,
             color=(0,0,1, i/10),
             label=fr"$h=2^{{ -{i} }}$"
            )

plt.legend()
plt.savefig(f"4-sample_path-brownian.pdf")




#%% Question 5
mu = 2
sigma = 1

def X(t, W): 
    """The actual stochastic process X(t)"""
    return np.exp((mu - sigma**2 / 2) * t + sigma * W)

plt.figure()
plt.title(r"Approximations of the sample path of $X$")
plt.xlabel(r"$t$")
plt.ylabel("$X(t)$")

def estimateX(h, W):
    """
    Compute an approximation of X at resolution h using the recursive formula.
    W is a sample path of a Brownian motion, used as the noise in the calculations.
    """
    N = int(1/h)
    
    Xh = 1
    Xhs = np.zeros(N+1)
    Xhs[0] = 1
    for n in range(1,N+1):
        Xh = (1 + h * mu) * Xh + sigma * Xh * (W[n] - W[n-1])
        Xhs[n] = Xh
    return Xhs

for h in resolutions:
    N = int(1/h)
    
    W = brownian(h, etas) # Generate brownian motion
    Xh = estimateX(h, W) # Approximate X
    
    # Plot
    i = int(np.log(N)/np.log(2))
    plt.plot(np.linspace(0, T, num=N+1), 
             Xh, 
             color=(0,0,1, i/10),
             label=fr"$h=2^{{ -{i} }}$"
            )

# Plot the "actual" path of X
t = np.linspace(0, T, num=maxN+1)
W = brownian(maxH, etas)
X_path = X(t, W)
plt.plot(t, X_path, color="orange", label=r"Actual path")

plt.legend()
plt.savefig(f"5-sample_path-X.pdf")




#%% Question 6
M=5000

counts = np.zeros(np.size(resolutions))
for m in range(M):
    # Randomize
    etas = np.random.normal(0, np.sqrt(maxH), maxN)
    # Compute the actual path
    t = np.linspace(0, T, num=maxN+1)
    X_path = X(t, brownian(maxH, etas))

    for i,h in enumerate(resolutions):
        # Estimate
        W = brownian(h, etas)
        Xh = estimateX(h, W)

        # Increase count
        counts[i] += (X_path[-1] - Xh[-1])**2
errors = np.sqrt(counts / M)

# Plot
plt.figure()
plt.title("Estimate of the strong error")
plt.xlabel(r"$h$")
plt.ylabel(r"Strong error")
plt.loglog(resolutions, errors, marker='o', label="Estimate")
plt.loglog(resolutions, np.sqrt(resolutions), label=r"Reference slope $h^{1/2}$")
plt.legend()
plt.savefig(f"6-strong_error.pdf")




#%% Question 7
M=5000

counts = np.zeros(np.size(resolutions))
for m in range(M):
    # Randomize
    etas = np.random.normal(0, np.sqrt(maxH), maxN)
    for i,h in enumerate(resolutions):
        # Estimate
        W = brownian(h, etas)
        Xh = estimateX(h, W)

        # Increase count
        counts[i] += Xh[-1]
E_X = np.exp(mu)
errors = np.abs(np.full(np.size(resolutions), E_X) - counts / M)

plt.figure()
plt.title(r"Estimate of the weak error with $\phi(x)=x$")
plt.xlabel(r"$h$")
plt.ylabel(r"Weak error")
plt.loglog(resolutions, errors, marker='o', label=r"Estimate with $\phi(x)=x$")
plt.loglog(resolutions, np.sqrt(resolutions), label=r"Reference slope $h^{1/2}$")
plt.legend()
plt.savefig(f"7-weak_error-identity.pdf")




#%% Question 8
M=5000

# phi = X(1)^2
def phi(x): return x**2

counts = np.zeros(np.size(resolutions))
for m in range(M):
    # Randomize
    etas = np.random.normal(0, np.sqrt(maxH), maxN)
    for i,h in enumerate(resolutions):
        # Estimate X
        W = brownian(h, etas)
        Xh = estimateX(h, W)

        # Increase count
        counts[i] += phi(Xh[-1])


# Compute errors
E_X = np.exp(2*mu + sigma**2)
errors = np.abs(np.full(np.size(resolutions), E_X) - counts / M)

plt.figure()
plt.title(r"Estimate of the weak error with $\phi(x)=x^2$")
plt.xlabel(r"$h$")
plt.ylabel(r"Weak error")
plt.loglog(resolutions, errors, marker='o', label=r"Estimate with $\phi(x)=x^2$")
plt.loglog(resolutions, np.sqrt(resolutions), label=r"Reference slope $h^{1/2}$")
plt.legend()
plt.savefig(f"8-weak_error-square.pdf")
