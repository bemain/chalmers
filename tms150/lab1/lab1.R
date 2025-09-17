install.packages("chron") # do this only once
install.packages("MASS") # do this only once


## Prepare data
# Load dataset
setwd("~/Chalmers/tms150/lab1")
bikesharing = read.csv("bikesharing.csv", header=TRUE)
bikesharing = data.frame(bikesharing)

# Format the `timestamp` variable as a date
library(chron) # load chron
bikesharing$timestamp = as.chron(bikesharing$timestamp) # convert to date
bikesharing$hrs = hours(bikesharing$timestamp) # create a "hours" variable
bikesharing$mnths = months(bikesharing$timestamp) # create a "months" variable

# Redefine categorical variables
bikesharing$weather_code = factor(bikesharing$weather_code,levels=c(1,2,3,4,7,10,26,94),
                                   labels=c("clear","semiclear","brkclouds","cloudy","lghtrain","thunderstorm","snow","freezing"))
bikesharing$is_holiday = factor(bikesharing$is_holiday, levels=c(0,1), labels=c(FALSE,TRUE))
bikesharing$is_weekend = factor(bikesharing$is_weekend, levels=c(0,1), labels=c(FALSE,TRUE))
bikesharing$season = factor(bikesharing$season, levels=c(0,1,2,3), labels=c("spring","summer","fall","winter"))





## i)
# Plot count vs. season
boxplot(bikesharing$cnt~bikesharing$season, xlab="season", ylab="number of bikes", cex.lab=1.5)

# Plot count vs. hour of the day
boxplot(bikesharing$cnt~bikesharing$hrs, xlab="hour of the day", ylab="number of bikes", cex.lab=1.5)






## ii)
# Extract the relevant data
norush = subset(bikesharing, !(hrs>=7 & hrs<=9) & !(hrs>=17 & hrs<=18)) # Exclude data from "rush hours"
data = subset(norush, season == "spring") # Only data from spring and excluding "rush hours"

# Plot
plot(bikesharing$hum, bikesharing$cnt, xlab="humidity", ylab="number of bikes", cex.lab=1.5, main="Entire dataset") # Plot entire dataset
plot(data$hum, data$cnt, xlab="humidity", ylab="number of bikes", cex.lab=1.5, main="“No-rush” data from spring") # Plot the filtered data

# Apply BoxCox transformation
m = lm(data$cnt+1 ~ data$hum) # We add 1 here to avoid BoxCox error: "response variable must be positive"
library(MASS) # Include required library
bc = boxcox(m) # Perform transformation

# Find the best lambda value
id_max <- which(bc$y==max(bc$y)) # The index of the best lambda
lambda <- bc$x[id_max] # Optimal lambda value

# Transform the response variable
cnt.trans = (data$cnt^lambda - 1)/lambda

# Apply linear regression
m = lm(cnt.trans ~ data$hum) # Fit the model to the transformed response

# Plot the transformed response
plot(data$hum, cnt.trans, xlab="humidity", ylab="y(λ)", main="Transformed data", cex.lab=1.5)
abline(m, col="red") # Fitted line
legend(85, 45, "E(y(λ)|x)", col=c("red"), pch="-")

# Plot residuals
plot(data$hum, m$residuals, xlab="humidity", ylab="y(λ)", main="Residuals", cex.lab=1.5)
abline(h=0, col="blue") # horizon, y=0
legend(25, 20, "Horizon line, y=0", col=c("blue"), pch="-")






## iii)
set.seed(321) # For reproducibility

n = 2000 # Number of simulated data points
hum = 40 # The humidity we want to simulate responses for

# Extract coefficients
b0.hat = m$coefficients[1]
b1.hat = m$coefficients[2]
s = summary(m)$sigma

# Simulate responses
eps = rnorm(n,0,s)
y.trans = b0.hat + b1.hat * hum + eps # Transformed predictions
y = (y.trans*lambda + 1)^(1/lambda) # Untransformed predictions
# hist(y)

# Calculate prediction interval
alpha = 0.05
q.low = quantile(y, alpha/2) # Lower quantile, 2.5%
q.high = quantile(y, 1-alpha/2) # Upper quantile, 97.5%

# Plot the predictions along with the quantiles
boxplot(y, ylab="number of bikes", main="Untransformed predictions for humidity=40")
abline(h=q.high, col="blue") # Upper quantile
text(1.4, q.high, "97.5% quantile", pos=3, col="blue")
abline(h=q.low, col="blue") # Lower quantile
text(1.4, q.low, "2.5% quantile", pos=3, col="blue")






## iv)
set.seed(321) # For reproducibility

# Split the data into training- and test-sets
N = nrow(data) # Size of the entire data set
n = floor(0.8*N) # Size of the training data
indices = sample.int(N, n) # Get n values from the sequence 1...N randomly
# Split the data set
y.train = data$cnt[indices]
x.train = data$hum[indices]
y.test = data$cnt[-indices]
x.test = data$hum[-indices]

gammas = seq(0.5, 2.0, 0.1) # We try different gamma values in [0.5, 2]
pMSE.sqrt = array(dim=length(gammas)) # will be filled, we just want the same length

# Function for calculating the pMSE, using x^gamma model
pMSE = function(gamma) {
  # Fit a x^gamma model to the BoxCox-transformed response
  z = x.train
  m = lm((y.train^lambda-1)/lambda ~ I(z^gammas[i]))
  # Predict y and calculate pMSE
  y.hat = predict(m, newdata=data.frame(z = x.test)) # Transformed predictions
  y.test.trans = (y.test^lambda-1)/lambda # Transformed test data
  return (sum((y.test.trans - y.hat)^2) /(N-n))
}

# For each value of gamma, we calculate the sqrt(pMSE) and save it
for (i in 1:length(gammas)) {
  pMSE.sqrt[i] = sqrt(pMSE(gammas[i]))
}

# Plot the pMSE values
plot(gammas, pMSE.sqrt, xlab="γ", ylab="√pMSE", cex.lab=1.5)






## v)
set.seed(321) # For reproducibility

K = 10 # Repeat the experiment 10 times
gammas = seq(0.5, 2.0, 0.1) # We try different gamma values in [0.5, 2]
pMSE.sqrt = array(dim=c(K, length(gammas))) # will be filled, we just want the same length

# For each value of gamma, we calculate the sqrt(pMSE) and save it for later
for (k in 1:K) {
  indices = sample.int(N, n) # Get n values from the sequence 1...N randomly
  # Split the data set
  y.train = data$cnt[indices]
  x.train = data$hum[indices]
  y.test = data$cnt[-indices]
  x.test = data$hum[-indices]
  
  for (i in 1:length(gammas)) {
    pMSE.sqrt[k,i] = sqrt(pMSE(gammas[i]))
  }
}

# Plot
par(mfrow = c(2,5))
gammas.min = array(dim=K)
for (k in 1:K) {
  plot(gammas, pMSE.sqrt[k,], xlab="γ", ylab="√pMSE", cex.lab=1.5)
  gammas.min[k] = gammas[which.min(pMSE.sqrt[k,])]
}






## vi)
set.seed(321) # For reproducibility

# Start with the model from earlier
m = lm((data$cnt^lambda-1)/lambda ~ data$hum)
b0.star = m$coefficients[1] # original B_0
b1.star = m$coefficients[2] # origianal B_1
s = summary(m)$sigma

B = 2000 # Number of iterations
alpha = 0.2

coeffs = array(dim=c(B,2)) # The parameter estimates for each iteration.
b0.included = 0 # The number of confidence intervals for b0 that contains the "actual" value b0.star
b1.included = 0 # The number of confidence intervals for b1 that contains the "actual" value b1.star
for (i in 1:B) {
  # Generate predictions
  eps = rnorm(length(data$hum),0,s)
  y.new = b0.star + b1.star * data$hum + eps # Transformed predictions
  
  # Fit a new model
  m = lm(y.new ~ data$hum)
  # Extract coefficients
  coeffs[i,] = m$coefficients
  # Generate confidence intervals
  # Note that these are for the transformed response variable, but it doesn't matter as we're only interested in the 
  # proportion of the intervals that contain the actual value, not the confidence intervals themselves.
  interval = confint(m, level = 1-alpha)
  if (interval[1,1] <= b0.star & b0.star <= interval[1,2]) {
    b0.included = b0.included + 1
  }
  if (interval[2,1] <= b1.star & b1.star <= interval[2,2]) {
    b1.included = b1.included + 1
  }
}

b0.prop = b0.included / B # The proportion of confidence intervals for b0 that contains the "actual" value b0.star  = 0.8105
b1.prop = b1.included / B # The proportion of confidence intervals for b1 that contains the "actual" value b1.star  = 0.8075
