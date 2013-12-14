
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

### (a) ############################################################################################
# 95% confidence interval for beta7:
beta.full[3] + c(-1,1) * qt(p = 0.025, df = df.full, lower.tail = FALSE) * beta.sd.full[3]
confint(object = lm.full, parm = 'x7', level = 0.95);

### (b) ############################################################################################
# 95% confidence interval for response variable given x2 = 2300, x7 = 56.00, x8 = 2100:

x0     <- matrix(c(1,2300,56.00,2100),nrow=4,ncol=1);
y0.hat <- as.numeric(t(x0) %*% beta.full); y0.hat;
y0.var <- MS.full * as.numeric(t(x0) %*% solve(t(X.full) %*% X.full) %*% x0);
y0.sd  <- sqrt(y0.var);
y0.hat + c(-1,1) * qt(p = 0.025, df = df.full, lower.tail = FALSE) * y0.sd;

q();

