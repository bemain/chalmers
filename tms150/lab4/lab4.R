install.packages('latex2exp')
install.packages('comprehenr')
install.packages('purrr')
library(latex2exp)
library(comprehenr)
library(purrr)

# Load data
setwd("~/Chalmers/tms150/lab4")
successful = read.csv("successful.txt", header=FALSE)[,1]
unsuccessful = read.csv("unsuccessful.txt", header=FALSE)[,1]




## Question 1
# (a)
Psuccess = function(x, mu, gamma) {
  # The probability that a product is successful given X=x
  exp((x-mu)*exp(-gamma))/(1+exp((x-mu)*exp(-gamma)))
}

# Plot the data
plot(unsuccessful, rep(0, length(unsuccessful)), xlim=c(0,32), xlab="x", ylim=c(0,1), ylab=TeX(r'(z)'), col="orange", main="The provided measurements")
points(successful, rep(1, length(successful)), col="lightgreen")

# Add curves
mus = c(8, 12, 14, 17, 20) # The mu values to try
gammas = c(-2.0, -1.0, 0.0, 1.0, 2.0) # The gamma values to try
colors = c("cyan", "darkcyan", "blue", "darkblue", "black")

x = seq(-10, 40, 0.1)
for (i in 1:length(mus)){
  # Compute the probability of success
  y = Psuccess(x, mus[i], gammas[i])
  # Plot
  lines(x, y, col = colors[i], lwd = 1)
}

legend("right", 
       legend=c(
         "Unsuccessful", 
         "Successful", 
         to_vec(for(i in 1:length(mus)) TeX(sprintf(r"(Estimate with $\mu$: %g, $\gamma$: %g)", mus[i], gammas[i])))), 
       fill=c("orange", "lightgreen", colors),
       lwd=c(0,0,1,1,1,1,1),
       )


## (b)
logpost = function(mu, gamma) {
  sum(log(Psuccess(successful, mu, gamma))) + sum(log(1 - Psuccess(unsuccessful, mu, gamma)))
}


## (c)
mus = seq(12, 17, 0.05)
gammas = seq(0, 2, 0.01)
# Compute the log-value for different parameters
logvals = matrix(, length(mus), length(gammas))
for (i in 1:length(mus)) {
  for (j in 1:length(gammas)) {
    logvals[i,j] = logpost(mus[i], gammas[j])
  }
}

vals = exp(logvals) # Posterior probabilities for different parameter values

# Show heatmap
image(mus,gammas,vals, xlab=TeX(r"($\mu$)"), ylab=TeX(r"($\gamma$)"), main="Posterior probabilities")



# Question 2
f = function(p) {
  # Maximixing logpost <=> minimizing (-logpost)
  return (-logpost(p[1], p[2]))
}

opt = nlm(f, c(14.5, 1.0)) # Perform minimization
# Optimal parameters
mu.hat = opt$estimate[1]
gamma.hat = opt$estimate[2]

# Plot the optimal parameters on the heatmap
points(mu.hat, gamma.hat, col="blue")
legend("bottomright", legend=c("Optimal", "High", "Medium", "Low"), fill=c("blue", "darkred", "orange", "khaki"))




## Question 3
b1 = 10
b2 = -6
b3 = -1

utility = function(x, z, theta) {
  # The utilities received x,z using theta as the threshold for success.
  supported = x>=theta # Whether the product was supported
  return (ifelse(supported, z*b1 + (1-z)*b2, b3))
}

sim.utility = function(N, theta, mu, gamma) {
  # The utilities received from N products, simulated and computed with the given parameters.
  
  x = rgamma(N, 2.5, 0.25) # Simulate X according to Gamma(2.5, 0.25)
  z = Psuccess(x, mu, gamma)>=runif(N)
  return (utility(x,z,theta))
}

# Parameters from the question
N = 10000
theta = 13
mu = 15
gamma = 1


# (a)
u = sim.utility(N, theta, mu, gamma) # Simulate

# Plot
hist(u, freq=TRUE, xlab=TeX(r"(Utility)"), main="Utility of simulated products")


# (b)
mean(sim.utility(N, theta, mu, gamma)) # Expected utility


# (c)
x = rgamma(N, 2.5, 0.25) # Simulate X according to Gamma(2.5, 0.25)
z = Psuccess(x, mu, gamma)>=runif(N)
thetas = seq(10, 20, 0.1)
expected = map(thetas, ~ mean(utility(x, z, .)))
plot(thetas, expected, xlab=TeX(r"($\theta$)"), ylab="Expected utility", main="Expected utility, computed using sample mean")




# Question 4
expected.utility = function(theta, mu, gamma) {
  inf = 100 # "Infinity". Integrating to actual Inf gives an overflow error
  f = function(x) dgamma(x, 2.5, 0.25)
  p = function(x) Psuccess(x, mu, gamma)
  integrate(function(x) utility(x, p(x), theta) * f(x), 0, inf)$value
}

expected.utility(theta, mu, gamma)

# Plot
thetas = seq(10, 20, 0.1)
expected = map(thetas, ~ expected.utility(., mu, gamma))
plot(thetas, expected, xlab=TeX(r"($\theta$)"), ylab="Expected utility", main="Expected utility, computed using numerical integration")




# Question 5
theta.hat = optimize(function(theta) expected.utility(theta, mu.hat, gamma.hat), c(10,16), maximum=TRUE)$maximum




# Question 6
expected.utility.mean = function(theta) {
  expected = outer(mus, gammas, Vectorize(expected.utility), theta=theta)
  sum(expected * vals)
}

theta.hat = optimize(expected.utility.mean, c(10,16), maximum=TRUE)$maximum

