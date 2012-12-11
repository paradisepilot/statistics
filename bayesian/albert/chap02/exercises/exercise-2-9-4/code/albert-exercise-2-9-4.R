
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);

### 2.9.4(a) #######################################################################################
p <- seq(0.1,0.5,0.1);
joe.prior <- data.frame(
	p       = p,
	density = c(50,20,20,5,5)/100,
	investigator     = rep("Joe",length(p)),
	stringsAsFactors = FALSE
	);
joe.prior;

mean.joe.prior <- sum(joe.prior[,'density'] * joe.prior[,'p']);
var.joe.prior  <- sum(joe.prior[,'density'] * (joe.prior[,'p']-mean.joe.prior)^2);

mean.beta <- function(a,b) { return(a/(a+b)); }
 var.beta <- function(a,b) { return(a*b/((a+b)^2 * (a+b+1))); }

mean.sam.prior <- mean.beta(a = 3, b = 12);
 var.sam.prior <-  var.beta(a = 3, b = 12);

c(mean.joe.prior, var.joe.prior);
c(mean.sam.prior, var.sam.prior);

### The mean and variance of Joe's prior respectively are: 0.195000, and 0.013475
### whereas those of Sam's respectively are: 0.20, and 0.01
### Hence, it is arguable that Joe's and Sam's prior beliefs are similar.

p <- seq(0,1,0.001);
sam.prior <- data.frame(
	p                = p,
	density          = dbeta(x = p, shape1 = 3, shape2 = 12),
	investigator     = rep("Sam",length(p)),
	stringsAsFactors = FALSE
	);

png("Fig1_prior-densities.png");
qplot(
	data  = rbind(joe.prior,sam.prior),
        x     = p,
        y     = density,
	color = investigator,
        geom  = c("line")
        );
dev.off();

sam.prior[,'density'] <- sam.prior[,'density'] / sum(sam.prior[,'density']);

### 2.9.4(b) #######################################################################################
n.trials <- 12;
y <- seq(0,n.trials,1);

temp.FUN <- function(x) {
	return(dbinom(x = x, size = n.trials, prob = joe.prior[,'p']))
	};

y.predicted.joe <- colSums(apply(
	X      = t(sapply(X = y, FUN = temp.FUN)),
	MARGIN = 1,
	FUN    = function(x) { return(x * joe.prior[,'density']) }
	));
DF.joe.prediction <- data.frame(
	y = y,
	predicted.density = y.predicted.joe,
	pdiscp = pdiscp(
		p = joe.prior[,'p'], 
		probs = joe.prior[,'density'],
		n = n.trials,
		s = y
		),
	investigator = rep("Joe",length(y)),
	stringsAsFactors = FALSE
	);
print( DF.joe.prediction );
print( sum(DF.joe.prediction[,'predicted.density']) );

temp.FUN <- function(x) {
	return(dbinom(x = x, size = n.trials, prob = sam.prior[,'p']))
	};

y.predicted.sam <- colSums(apply(
	X      = t(sapply(X = y, FUN = temp.FUN)),
	MARGIN = 1,
	FUN    = function(x) { return(x * sam.prior[,'density']) }
	));
DF.sam.prediction <- data.frame(
	y = y,
	predicted.density = y.predicted.sam,
	pbetap = pbetap(
		ab = c(3,12), 
		n = n.trials,
		s = y
		),
	investigator = rep("Sam",length(y)),
	stringsAsFactors = FALSE
	);
print( DF.sam.prediction );
print( sum(DF.sam.prediction[,'predicted.density']) );

png("Fig2_predicted-densities.png");
DF.temp <- rbind(
	DF.joe.prediction[,c('y','predicted.density','investigator')],
	DF.sam.prediction[,c('y','predicted.density','investigator')]
	);
qplot(
	data  = DF.temp,
        x     = y,
        y     = predicted.density,
	color = investigator,
        geom  = c("line")
        );
dev.off();

