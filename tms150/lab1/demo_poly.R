set.seed(100)  # set the seed of the pseudorandom numbers, for reproducibility

# here we generated data (x,y)
nobs = 100  # number of observations
x <- runif(nobs,min=1,max=50)  # sample uniformly 100 draws in (1,50)
y <- 2 + 50*x -5*x^2 + 0.09*x^3 + rnorm(nobs,0,150)
plot(x,y, cex.lab = 1.5)   # I like to increse the fontsize of the labels by 50% using cex.lab=1.5 instead of =1  

# now let's create a finer grid x0 of values that we will later use for prediction 
x0 <- seq(from=-10,to=60, by=0.01)  

# plot the TRUE expected response, that is E(y) = f(x) = 2 + 50*x -5*x^2 + 0.09*x^3
lines(x0, 2 + 50*x0 -5*x0^2 + 0.09*x0^3)

# now we fit several polynomial regression models:

#order 2
m2<-lm(y~poly(x,2,raw=TRUE))   # same as lm(y~x+I(x^2))
y0 <- predict(m2, newdata = data.frame(x = x0))  
lines(x0, y0, col = "magenta")  
summary(m2)$r.squared

# also, you might be interested in checking the whole output of the summary function
summary(m2)
# the output interpretation is the same as for summary(lm(y~x+I(x^2)))

#order 3
m3 <-lm(y~poly(x,3,raw=TRUE))
y0 <- predict(m3, newdata = data.frame(x = x0))  
lines(x0, y0, col = "green")
legend(20, 1000, legend=c("true model", "quadratic","cubic"),col=c("black", "magenta","green"), lty=1, cex=1.5)
summary(m3)$r.squared

#order 5
m5 <-lm(y~poly(x,5,raw=TRUE))
y0 <- predict(m5, newdata = data.frame(x = x0))  
lines(x0, y0, col = "gray")
summary(m5)$r.squared

#order 10
m10 <-lm(y~poly(x,10,raw=TRUE))
y0 <- predict(m10, newdata = data.frame(x = x0))  
lines(x0, y0, col = "cyan")  
summary(m10)$r.squared

#order 20
m20 <-lm(y~poly(x,20,raw=TRUE))
y0 <- predict(m20, newdata = data.frame(x = x0))  
lines(x0, y0, col = "blue") 
summary(m20)$r.squared

# let's store all R^2 we computed in a vector then plot them
myrsquared <- c(summary(m2)$r.squared,summary(m3)$r.squared,summary(m5)$r.squared,summary(m10)$r.squared,summary(m20)$r.squared)
# here we have a simple plot without frills
plot(c(2,3,5,10,20),myrsquared)
# and here we have the same plot, but taking care of adding some nice options to please the eye
plot(c(2,3,5,10,20),myrsquared,type="b",ylim=c(0,1),xlab="order p of polynomial", ylab="R-squared",main="all the several R-squared",cex.lab=1.5,cex.axis=2,cex.main=2)
# the option type = "b" adds a line that connects dots
# the option cex.axis controls the size of the tick mark labels; default value is 1.
# the option cex.main controls the size of the main title; default value is 1.


# redo plots with a larger range for the x-axis
plot(x,y, cex.lab = 1.5, xlim = c(-10,60))   # I like to increse the fontsize of the labels by 50% using cex.lab=1.5 instead of =1  
y0 <- predict(m3, newdata = data.frame(x = x0))  
lines(x0, y0, col = "green")
y0 <- predict(m10, newdata = data.frame(x = x0))  
lines(x0, y0, col = "cyan")  
legend(20, 1000, legend=c("cubic", "order 10"),col=c("green", "cyan"), lty=1, cex=1.5)
y0 <- predict(m20, newdata = data.frame(x = x0))  
lines(x0, y0, col = "blue")
legend(20, 1000, legend=c("cubic", "order 10", "order 20"),col=c("green", "cyan", "blue"), lty=1, cex=1.5)


# an example of how to extract randomly observations from a matrix, useful to create training/testing datasets

# say thet we have data into a 30 x 2 matrix D
D <- matrix(runif(60),ncol=2)   # suppose these are data
my_x <- D[,1]  #  covariate
my_y <- D[,2]  #  response
#obtain training data having size n=20
index <- sample.int(30,20)  # samples 20 times without replacement from 1,2,...,30 
xtrain <- my_x[index]  # training covariate
ytrain <- my_y[index]  # training response"
xtest  <- my_x[-index]  # testing covariate
ytest  <- my_y[-index]  # testing response"
