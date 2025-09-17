# load the "cars" dataset
data(cars)  # it works because this dataset is already provided within the R program. Otherwise you typically need read.table()
cars  # display the loaded dataset
attach(cars)  # read the columns names in the dataset
plot(speed, dist)  # scatterplot

# note: if we did NOT use attach(), we would be forced to write plot(cars$speed, cars$dist) 

# optional: redefine the axes labels. Also, increase the font of the labels
plot(speed, dist, xlab="speed", ylab="distance", cex.lab=1.5)  # scatterplot

# fit a linear model (lm)
m1 = lm(dist~speed)  # we call it m1 but you can give it any name you want

# we want to fit E(distance|speed) = b0 + b1*speed

m1  # just run this, to observe the estimated coefficients

# We can use the "$" to extract information from R "objects"

# another way to look at estimated coefficients
m1$coefficients

# or look at one coefficient at a time
m1$coefficients[1]  # extract the intercept
m1$coefficients[2]  # extract the slope

abline(m1)  # add fitted line to previous plot (warning: it only works with m1, not with m2,..,m5 defined below)

m1$fitted.values  # returns the estimated expected responses E(y|x) at observed values of x

# fit quadratic model
m2<-lm(dist~speed+I(speed^2))  # I() stands for "as is". It's necessary to express powers within the lm() function.

# PLOT!

# now produce plots of the estimated m2, by predicting from a grid of x0 values defined as below
x0 = seq(min(speed), max(speed), length = 100)  # sequence of length 100, equispaced between min(speed) and max(speed)
# estimate E(y) according to x0
E0 = predict(m2, newdata = data.frame(speed = x0))  # estimated expected distance using model m2 based on speed set at x0 
# add the predictions we have just obtained to the plot with data
lines(x0, E0, col = "red")  # add regression curve (colour: red)

# for best readability, we add a legend. We place it around the point with coordinates (5,95). The parameter lty=1 specifies solid lines
legend(5,95, legend=c("linear", "quadratic"), col=c("black","red"), lty=1 )

# uhm... the font seems small. Might look bad when printed. Let's enlarge it by 30% using cex=1.3 (default is cex=1)
legend(5,95, legend=c("linear", "quadratic"), col=c("black","red"), cex=1.3, lty=1 )

m5<-lm(dist~poly(speed,5,raw=TRUE)) # shorthand for lm(dist~speed+I(speed^2)+I(speed^3)+I(speed^4)+I(speed^5))
E0 <- predict(m5, newdata = data.frame(speed = x0))  # estimated expected distances at x0 based on model m5
lines(x0, E0, col = "green")  
legend(5, 95, legend=c("linear", "quadratic","degree 5"),col=c("black", "red","green"), cex=1.3, lty=1 )

# suppose for whatever reason you wish to fit a model on the
# data except for observation in row 5.
# method 1:
m_without_5 <- lm(dist~speed, data = cars[-5,]) # notice we used the data option and asked to ignore the 5th row
# method 2:
data_without_5 <- cars[-5,]  # create a subset without row 5
m_without_5 <- lm(data_without_5$dist~data_without_5$speed)  # we used the $ to make sure to use the right dataset

# Warning: the following would NOT work
attach(m_without_5)
lm(dist~speed)  # this gives the estimates based on the full dataset as for R dist and speed are from the first dataset (the full one).
                # the previous "attach" function did not overwrite the initial one.
# So, all in all, if you plan to use different datasets, either use the $ to make sure you
# use the right data (as in method 2), or use the "data = ... " option in lm() as in method 1

