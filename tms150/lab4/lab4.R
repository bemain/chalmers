install.packages('latex2exp')
install.packages('comprehenr')
library(latex2exp) # load latex2exp
library(comprehenr)

## Question 1 (a)
# Load data
setwd("~/Chalmers/tms150/lab4")
successful = read.csv("successful.txt", header=FALSE)[,1]
unsuccessful = read.csv("unsuccessful.txt", header=FALSE)[,1]

Psuccess = function(x, mu, gamma) {
  # The probability that a product is successful given X=x
  exp((x-mu)*exp(-gamma))/(1+exp((x-mu)*exp(-gamma)))
}

# Plot the data
plot(unsuccessful, rep(0, length(unsuccessful)), xlim=c(0,32), xlab="x", ylim=c(0,1), ylab=TeX(r'($P(success)$)'), col="orange")
points(successful, rep(1, length(successful)), col="lightgreen")

# Add curves
mus = c(10, 12, 15, 18, 20) # The mu values to try
gammas = c(-1.0, -0.5, 0.0, 0.5, 1.0) # The gamma values to try
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

# Conclusion: mu = 14, gamma = 1 might be reasonable



## Question 1 (b)
logpost = function(mu, gamma) {
  sum(log(Psuccess(successful, mu, gamma))) + sum(log(1 - Psuccess(unsuccessful, mu, gamma)))
}



## Question 2 (c)
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
image(mus,gammas,vals, xlab=TeX(r"($\mu$)"), ylab=TeX(r"($\gamma$)"), main="Heatmap of posterior density")

# mu [14, 15],  gamma [0.9, 1.2]



# Question 3
f = function(p) {
  return (-logpost(p[1], p[2]))
}

opt = nlm(f, c(14.5, 1.0))
mu.hat = opt$estimate[1]
gamma.hat = opt$estimate[2]

# Plot the optimal parameters on the heatmap
points(mu.hat, gamma.hat, col="blue")
legend("bottomright", legend=c("Optimal", "High", "Medium", "Low"), fill=c("blue", "darkred", "orange", "khaki"))
