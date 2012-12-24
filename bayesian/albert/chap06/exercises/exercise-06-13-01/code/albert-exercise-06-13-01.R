
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
require(LearnBayes);
require(ggplot2);
require(scales);
require(coda);
#require(sn);

#source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

### Exercise 6.13.1(a) #############################################################################
P <- matrix(
	data = c(
		0.2, 0.2, 0,   0,   0,
		0.8, 0.2, 0.4, 0,   0, 
		0,   0.6, 0.2, 0.6, 0,
		0,   0,   0.4, 0.2, 0.8,
		0,   0,   0,   0.2, 0.2
		),
	byrow = TRUE,
	nrow  = 5,
	ncol  = 5
	);
P;

states         <- seq(1,5,1);
length.of.walk <- 1e+6;
random.walk    <- numeric(length.of.walk);
random.walk[1] <- states[1];

for (i in 2:length(random.walk)) {
	random.walk[i] <- sample(size = 1, x = states, prob = P[,random.walk[i-1]]);
	}

### Exercise 6.13.1(b) #############################################################################
cbind(states, table(random.walk) / length(random.walk));

### Exercise 6.13.1(c) #############################################################################
eigen.P <- eigen(P);
eigen.P;

###  The stationary distribution of the Markov Chain defined by the transition matrix P
###  is precisely the vector v1 below.
###  Note that v1 is determined precisely as follows:
###    (a)  v1 is an eigenvector of P corresponding to the eigenvalue of 1, and
###    (b)  the components of v1 sum to 1.

v1 <- eigen.P[['vectors']][,1];
v1 <- v1 / sum(v1);
cbind(v1, P %*% v1);
colSums(cbind(v1, P %*% v1));

####################################################################################################

q();

