data(iris)
?iris # to read more about this dataset
attach(iris)

m <- lm(Sepal.Length~Sepal.Width + Petal.Length + Petal.Width)
m  # lets give a look at coefficients

# I want to obtain those OLS estimates "by hand".

# let's fetch X automatically. Need the x=TRUE option

m <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, x=TRUE)
X <- m$x  # this works because I used x=TRUE

# betahat = (X'X)^(-1)X'Y
betahat <- solve(t(X)%*%X)%*%t(X)%*%Sepal.Length  # the OLS parameter estimates

betahat  # same as m$coefficients

# compute predicted responses "by hand" (notice we use matrix multiplication)
yhat <- X %*% m$coefficients # this is yhat = X %*% betahat

# verify that is the same as...
m$fitted.values

# notice, in multiple regression the estimate of sigma (the standard deviation of the error term epsilon), 
# uses n-(number of parameters) at the denominator

n = length(Sepal.Length)
s = sqrt(sum(m$residuals^2) / (n-4))  # we have 4 parameters including intercept
#compare with
summary(m)$s

# to get the R-squared
summary(m)$r.squared
# or look into summary(m)
