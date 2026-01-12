# Use packages
library("expm")
library("LearnBayes")

# The data from Figure 1:
# Read like this: the time is when the state below it ended.
times <- c(1.7, 5.6, 7.9, 8.3, 10.2, 11.5, 12.7, 14.1, 14.5, 16, 20.4, 24.7, 26.3)
states <- c(1 , 4  , 1  , 4  , 1   , 3   , 2   , 4   , 2   , 1 , 3   , 1   , 2   )
data <- cbind(times, states)

alphas <- matrix( rep(1,4*4), nrow=4 ) - diag(4)
counts <- matrix(rep(numeric(4), 4), nrow=4)
for ( k in 1:(length(states)-1) ) {
  i <- states[k]
  j <- states[k+1]
  counts[i, j] <- counts[i, j] + 1
}

# a) ####

# See the report for the posterior

# Expected values of transition matrix:
expected_value_P_i <- function(alpha_i, c_i) {
  return( ( alpha_i + c_i ) / ( sum(alpha_i) + sum(c_i) ) )
}

expected_value_P <- matrix(rep(numeric(4), 4), nrow=4)
for (k in 1:4){
  expected_value_P[k, ] <- expected_value_P_i(alphas[k, ], counts[k, ])
}

# Answer:
expected_value_P

# b) ####

# Calculate total holding times for each state
h <- numeric(4)
n <- numeric(4)
for (i in 1:4) {
  h[i] <- 0
  n[i] <- length(which(states == i))
  for ( j in which(states == i) ){
    if (j == 1) {
      h[i] <- h[i] + times[j]
    }
    else {
      h[i] <- h[i] + times[j] - times[j-1]
    }
  }
}

# Expected value of posterior of holding times:
answer_b <- n / h
answer_b

# c) ####

# Long-term probability
get_Q <- function(trans_matrix, q) {
  size <- nrow(trans_matrix)
  Q <- matrix(rep(numeric(size), size), nrow=size)
  for (i in 1:size) {
    for (j in 1:size) {
      if (i == j) {
        Q[i,j] <- -q[i]
      }
      else {
        Q[i,j] <- trans_matrix[i,j] * q[i]
      }
    }
  }
  return(Q)
}

long_term_prob <- function(trans_matrix, q) {
  Q <- get_Q(trans_matrix, q)
  return(expm(1000*Q))
}

# Answer: (It does not matter which row we pick if a limiting distribution exists)
long_term_probability <- long_term_prob(expected_value_P, answer_b)[1, ]
long_term_probability[3]


# d) ####

alpha_cs <- alphas + counts 

iterations <- 10000
result <- numeric(iterations)
for (i in 1:iterations) {
  P1 <- rdirichlet(1, alpha_cs[1,])
  P2 <- rdirichlet(1, alpha_cs[2,])
  P3 <- rdirichlet(1, alpha_cs[3,])
  P4 <- rdirichlet(1, alpha_cs[4,])
  P_tilde <- rbind(P1, P2, P3, P4)
  
  q1 <- rgamma(1, n[1], h[1])
  q2 <- rgamma(1, n[2], h[2])
  q3 <- rgamma(1, n[3], h[3])
  q4 <- rgamma(1, n[4], h[4])
  q <- c(q1,q2,q3,q4)
  
  result[i] <- long_term_prob(P_tilde, q)[1,3]
}
mean(result)

# e) ####

states_counter <- numeric(4)
for (i in 1:iterations) {
  P1 <- rdirichlet(1, alpha_cs[1,])
  P2 <- rdirichlet(1, alpha_cs[2,])
  P3 <- rdirichlet(1, alpha_cs[3,])
  P4 <- rdirichlet(1, alpha_cs[4,])
  P_tilde <- rbind(P1, P2, P3, P4)
  
  q1 <- rgamma(1, n[1], h[1])
  q2 <- rgamma(1, n[2], h[2])
  q3 <- rgamma(1, n[3], h[3])
  q4 <- rgamma(1, n[4], h[4])
  q <- c(q1,q2,q3,q4)
  
  current_state <- 2
  current_time <- 26.3
  while (current_time < 30) {
    current_time <- current_time + q[current_state]
    if (current_time < 30) {
      current_state <- sample(1:4, 1, prob = P_tilde[current_state, ])
    }
  }
  states_counter[current_state] <- states_counter[current_state] + 1
}

states_counter / sum(states_counter)

# f) ####

result <- matrix(rep(numeric(4), iterations), nrow=iterations)
for (i in 1:iterations) {
  P1 <- rdirichlet(1, alpha_cs[1,])
  P2 <- rdirichlet(1, alpha_cs[2,])
  P3 <- rdirichlet(1, alpha_cs[3,])
  P4 <- rdirichlet(1, alpha_cs[4,])
  P_tilde <- rbind(P1, P2, P3, P4)
  
  q1 <- rgamma(1, n[1], h[1])
  q2 <- rgamma(1, n[2], h[2])
  q3 <- rgamma(1, n[3], h[3])
  q4 <- rgamma(1, n[4], h[4])
  q <- c(q1,q2,q3,q4)
  
  Q <- get_Q(P_tilde, q)
  exp_matrix <- expm( (30-26.3) * Q)
  result[i,] <- exp_matrix[2,]
}

time_30_distr <- c( sum(result[,1]), sum(result[,2]), sum(result[,3]), sum(result[,4]) )
time_30_distr / sum(time_30_distr)