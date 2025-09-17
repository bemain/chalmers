# Start RStudio

# this is a comment. Use "#" to document your code 

# place the mouse cursor in any line of this script, then you may click the "Run" button that you find just above this window, slightly on the right
# this way you can rapidly execute each line

# Objects
y <- 5 # "assignment" (see Environment window)
y
y = 5
x <- 8 - y
x
y

# Functions
sqrt(16)  # square root
abs(-3)   # absolute value

# Data types
today <- "Monday"
today
a <- FALSE
a
!a  # ! is the logical "FALSE", the opposite of "TRUE". So here we apply FALSE to a (and a=FALSE), so the opposite of a is TRUE

# Important data types: vectors and matrices
numbers <- c(5, 6, 4, 7, 3)  # c for concatenate
numbers
numbers[2]    # display the second element
numbers[3:5]  # display all elements from the 3rd to the 5th
numbers[-4]   # display all ements except the 4th
numbers + 3
numbers
# ranges
numbers <- 3:8
numbers
numbers <- seq(4, 11, 0.3)  # a sequence from 4 to 11, using increments of size 0.3
numbers
# repeat
numbers <- rep(4, 3) # repeats number 4 for three times
numbers
# concatenate
numbers <- c(numbers, 6:8)
# matrices
A <- matrix(1:12, 3, 4)  # arrange intergers from 1 to 12 into a matrix with three rows and four columns
A
A[2, ]  # display the second row
A[, 3]  # the 3rd column
A[, 2:4]
A[3, 4] <- 100   
A

# Getting help
?matrix # or help(matrix)
help.search("column sums")
colSums(A)
help.start() # (also New window -> An Intro to R)

# Installing and loading a package
# for example say you want to install the "dplyr" package
install.packages("dplyr")
# You can also do that by clicking on the tab "Packages" in the Rstudio bottom-right panel.
# Installing a package is not enough to be able to use it. 
# You must also load it using "library"
library(dplyr)

# Graphics
x <- 0:20
y <- x^2
plot(x, y)

# Environment (workspaces) and History
# show in RStudio
ls()
# press Up-key
# Can save the workspace (or when quitting)

# Scripting
# Open new R script
# in new file window:
a <- 5
print(a)
# save file: "example"
# in console:
# source("example.R")
# add comment in file:
# this prints "5"

# Data frames (important and very useful!)
# in file:
table <- data.frame(letter=c("a", "b", "c"), number=4:6, w=c(3, 5, 1))
# source file
# in console:
table

# vector and matrix computation
x <- c(1,2,3,4) #vector assignment (c=concatenate)
y<-1:8 #(vector assignment)
y*2
y <- 1:8 + 5
y*x # elementwise multiplication
y>=6 # true for elements of y that are >= 6
(y>6 & y<=4)
sum(y<6)
y[y>=6]

# sample 10 times from the normal distribution with mean 0 and standard deviation 1
rnorm(10)

# sample 1000 times from the normal distribution with mean 3 and standard deviation 1.5
sample <- rnorm(1000,3,1.5)
# produce an histogram
hist(sample)

# apply
test<-matrix(rnorm(30),ncol=3) #create a matrix with 3 columns from a random vector of 30 elements simulated from a standard Gaussian 
apply(test,2,mean) #apply mean to each column
apply(test,1,mean) #apply mean to each row

# create functions
myfun<-function(x){
  y=2*x+3
  return(y)
}
myfun(5)
apply(test,2,myfun) #apply own function
apply(test,2,function(x) mean(x)-5) #define function directly
myfun <- function(x) 2*x+3

# matrix sub-setting again
test[1,1] #sub-setting
test[,2] #all elements in second column
test[,c(2,3)] #all elements in second and third column


# for-loop
for (i in 1:10){
  print(i)
}

