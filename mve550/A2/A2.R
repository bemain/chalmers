library(latex2exp)
setwd("~/Chalmers/mve550/A2")

### Question 1
data = read.table("dataAssignment2.txt", header=TRUE)
healthy = data[data$z==0, ]
sick = data[data$z==1, ]


## a)
f = Vectorize( function(x,y,theta) {
  u = exp(theta[1])*(x - theta[2])
  v = exp(theta[3])*(y - theta[4])
  q = theta[5] - u^2 - v^2 - 2*u*v * (exp(theta[6]) - 1) / (exp(theta[6]) + 1)
  return(exp(q) / (1+exp(q)))
}, vectorize.args = c("x", "y"))

plot(data$x, data$y, col=ifelse(data$z, "red", "blue"), main="Observed data", xlab="x", ylab="y")
legend("topright", c("healthy", "have developed disease"), pch=1, col=c("blue", "red"))


## c)
# Not normalized
log.posterior = function(theta) {
  sum(log(f(sick$x, sick$y, theta))) + sum(log(1-f(healthy$x, healthy$y, theta)))
}

log.quotient = function(theta1, theta2) {
  log.posterior(theta1) - log.posterior(theta2)
}


## d)
mcmc = function(n=10000) {
  theta = rep(1, 6)
  chain = matrix(NA, nrow=n, ncol=length(theta))
  for (i in 1:n) {
    theta.new = theta + rnorm(length(theta), 0, 0.1)
    a = log.quotient(theta.new, theta)
    if(runif(1) < exp(a)) {
      theta = theta.new
    }
    chain[i,] = theta
  }
  return (chain)
}

chain = mcmc()

plot(chain[,1], type="n", xlab="index", ylab="simulated values", ylim=c(-2,5), main="Trace plot for MCMC") # Empty plot
cols = c("green", "blue", "red", "orange", "yellow", "magenta")
for (i in 1:6) {
  lines(chain[,i], col = cols[i])
}
legend("topleft", c(TeX(r"($\theta_1$)"), TeX(r"($\theta_2$)"), TeX(r"($\theta_3$)"), TeX(r"($\theta_4$)"), TeX(r"($\theta_5$)"), TeX(r"($\theta_6$)")), pch=1, col=cols)



## e)
thetas = chain[1000:nrow(chain),]
p.disease = mean(apply(thetas, 1, function(theta) {
  f(2, 2.5, theta)
})) # 0.1854039

choose(10, 7)* p.disease^7 * (1-p.disease)^3 # 0.0004884731
