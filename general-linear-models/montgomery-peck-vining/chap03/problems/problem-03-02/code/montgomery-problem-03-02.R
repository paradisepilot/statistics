
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
my.pvalue <- function(x = NULL) { return(ifelse(x < 0.5,2*x,2*(1-x))); }

generate.indicator <- function(x = NULL, label = NULL) {
	output <- rep(0,length(x));
	output[x == label] <- 1;
	return(output);
	}

####################################################################################################
library(MPV);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- table.b1;
DF.data <- DF.data[,c('y','x2','x7','x8')];
lm.full <- lm(formula = y ~ x2 + x7 + x8, data = DF.data);
#str(DF.data);
#DF.data;

X.full       <- as.matrix(cbind(intercept = rep(1,nrow(DF.data)),DF.data[,c('x2','x7','x8')]));
beta.full    <- solve(t(X.full) %*% X.full) %*% t(X.full) %*% DF.data[,'y'];
yhat.full    <- X.full %*% beta.full;
SS.full      <- sum((DF.data[,'y']-yhat.full)^2);
df.full      <- nrow(X.full) - ncol(X.full);
MS.full      <- SS.full / df.full;
beta.sd.full <- sqrt(MS.full * diag(solve(t(X.full) %*% X.full)));
t.stats      <- beta.full / beta.sd.full;
pvalues      <- my.pvalue(pt(q = t.stats, df = df.full));

cbind(beta.full,beta.sd.full,t.stats,pvalues);
summary(lm.full);

### R-squared:
SS.grand.mean <- sum((DF.data[,'y'] - mean(DF.data[,'y']))^2);
R.squared <- 1 - SS.full / SS.grand.mean; R.squared;

covYYhat <- sum((DF.data[,'y']-mean(DF.data[,'y']))*(yhat.full-mean(yhat.full)));
varY     <- sum((DF.data[,'y']-mean(DF.data[,'y']))^2);
varYhat  <- sum((yhat.full-mean(yhat.full))^2);
corYYhat <- covYYhat / sqrt(varY * varYhat);
c(corYYhat, cor(DF.data[,'y'],yhat.full));
corYYhat^2;

q();

