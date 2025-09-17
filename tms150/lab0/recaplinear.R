## Experiment 1

setwd("~/Chalmers/tms150")

# Load data set
sleeptab = read.table('lab0/sleeptab.dat', header=TRUE)
attach(sleeptab)

plot(bwt, brwt)

# Remove outliers (Elephants + man)
filtered = sleeptab[brwt<1000,]
attach(filtered)
plot(bwt, brwt)

# Predict using built-in
model = lm(brwt~bwt)

# Predict "manually"
n = length(bwt)
xmean = sum(bwt)/n
ymean = sum(brwt)/n
b1hat = sum(mapply(function(i) (bwt[i] - xmean) * brwt[i], 1:n)) / sum((bwt - xmean)^2)
b0hat = ymean - b1hat*xmean



## Experiment 2
# Plot residuals
plot(bwt, model$residuals)

# New model on log-transformed variables
logmodel = lm(log(brwt)~log(bwt))
plot(log(bwt), log(brwt))
abline(logmodel)

plot(log(bwt), logmodel$residuals)

# Estimate brain weight using the two models to see difference
predict(model, newdata = data.frame(bwt = 1000))
exp(predict(logmodel, newdata = data.frame(bwt = 1000)))


## Experiment 3: Confidence intervals
# Calculate s "by hand"
n = length(bwt)
yhat = model$fitted
s = sqrt(sum((brwt - yhat)^2) / (n-2))

# Calculate confint "by hand"
alpha = 0.1
xmean = sum(bwt)/n
t = qt(alpha/2, n-2)

b0hat = model$coefficients[1]
db0hat = t * s * sqrt(1/n + xmean^2 / sum((bwt - xmean)^2))
Ib0 = c(b0hat + db0hat, b0hat - db0hat)

b1hat = model$coefficients[2]
db1hat = t * s / sqrt(sum((bwt - xmean)^2))
Ib1 = c(b1hat + db1hat, b1hat - db1hat)



## Experiment 4
b0star = model$coefficients[1]
b1star = model$coefficients[2]

alpha = 0.1
n = length(bwt)
yhat = model$fitted
s = sqrt(sum((brwt - yhat)^2) / (n-2))

m = 2000
b0 = array(dim=m)
b1 = array(dim=m)
confints = array(dim=c(m, 2, 2))

for (i in 1:m) {
  epsilon = rnorm(n, sd = s)
  brwt_new = b0star + b1star * bwt + epsilon
  model_new = lm(brwt_new~bwt)
  b0[i] = model_new$coefficients[1]
  b1[i] = model_new$coefficients[2]
  confints[i,,] = confint(model_new, level = 1-alpha)
}

