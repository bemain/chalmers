library(latex2exp)


#%% Question 1

# a)
lambda = seq(5, 20, length.out=1000)
posterior = dgamma(lambda, 58, 5)
plot(lambda, posterior, type="l", main=TeX(r"(Posterior density for $\lambda$)"), xlab=TeX(r"($\lambda$)"), ylab=TeX(r"($\pi(\lambda| x_1,...,x_5)$)"))


# b)
x = seq(0,40,1)  # New values
predictive = dnbinom(x, 58, 5/6)
plot(x, predictive, type="p", main="Posterior predictive density for X", xlab=TeX(r"($x$)"), ylab=TeX(r"($\pi(x)$)"))


# c)
step = 0.1
lambda = seq(5, 20, step)
likelihood = function(lambda) {
  # The likelihood of observing the given data given parameter lambda
  dpois(13, lambda)*dpois(14, lambda)*dpois(14, lambda)*dpois(7, lambda)*dpois(10, lambda)
}
posterior.discrete = likelihood(lambda) * 1 / lambda
posterior.discrete = posterior.discrete / sum(posterior.discrete) # Normalize
plot(lambda, posterior.discrete, type="p", main=TeX(r"(Posterior density for $\lambda$)"), xlab=TeX(r"($\lambda$)"), ylab=TeX(r"($\pi(\lambda| x_1,...,x_5)$)"), ylim=c(0, 0.04))

x.new = 14
predictive.discrete = sum(dpois(x.new, lambda)*posterior.discrete) # 0.07850225 compared to 0.07850217 when using analytical


# d)
prior = function(lambda) {
  dnorm(lambda, 10, 2)
}
posterior.inform = likelihood(lambda) * prior(lambda)
posterior.inform = posterior.inform / sum(posterior.inform) # Normalize
points(lambda, posterior.inform, col="blue", main=TeX(r"(Posterior density for $\lambda$, with informative prior)"), xlab=TeX(r"($\lambda$)"), ylab=TeX(r"($\pi(\lambda| x_1,...,x_5)$)"), ylim=c(0, 0.35))
legend("topright", c(TeX(r"(Using uniform prior $\pi(\lambda)=1/\lambda $)"), TeX(r"(Using informative prior $\lambda\sim N(10,2^2)$)")), pch=1, col = c("black", "blue"))

x.new = 14
predictive.inform = sum(dpois(x.new, lambda)*posterior.inform) # 0.07269832


# e)
plot(lambda, step*prior(lambda), type="l", xlab=TeX(r"($\lambda$)"), ylab="probability", ylim=c(0, 0.04))
points(lambda, posterior.inform, col="blue")
l.scaled = likelihood(lambda) / sum(likelihood(lambda))
points(lambda, l.scaled, col="green")
legend("topright", c(TeX(r"(Prior $\lambda\sim N(10,2)$)"), "Posterior", "Scaled likelihood"), pch=1, col = c("black", "blue", "green"))


# f)
upper = 20 # If we use a larger upper we get a huge error. Nothing "interesting" happens beyond this anyway.
scale = integrate(function(lambda) {
  likelihood(lambda) * prior(lambda)
}, 5, upper)$value

x.new = 14
f = function(lambda) {
  dpois(x.new, lambda) * likelihood(lambda) * prior(lambda)
}
predictive.integr = integrate(f, 0, upper)$value / scale # 0.07269832

