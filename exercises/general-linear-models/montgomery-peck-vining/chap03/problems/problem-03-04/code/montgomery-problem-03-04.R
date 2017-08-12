
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
#str(DF.data);
#DF.data;

lm.full    <- lm(formula = y ~ x2 + x7 + x8, data = DF.data);
lm.reduced <- lm(formula = y ~      x7 + x8, data = DF.data);

### full model #####################################################################################
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

### reduced model ##################################################################################
X.reduced       <- as.matrix(cbind(intercept = rep(1,nrow(DF.data)),DF.data[,c('x7','x8')]));
beta.reduced    <- solve(t(X.reduced) %*% X.reduced) %*% t(X.reduced) %*% DF.data[,'y'];
yhat.reduced    <- X.reduced %*% beta.reduced;
SS.reduced      <- sum((DF.data[,'y']-yhat.reduced)^2);
df.reduced      <- nrow(X.reduced) - ncol(X.reduced);
MS.reduced      <- SS.reduced / df.reduced;
beta.sd.reduced <- sqrt(MS.reduced * diag(solve(t(X.reduced) %*% X.reduced)));
t.stats         <- beta.reduced / beta.sd.reduced;
pvalues         <- my.pvalue(pt(q = t.stats, df = df.reduced));

cbind(beta.reduced,beta.sd.reduced,t.stats,pvalues);
summary(lm.reduced);

### (a) ############################################################################################
F.stat <- (sum((yhat.reduced - mean(DF.data[,'y']))^2) / (ncol(X.reduced) - 1)) / MS.reduced;
F.stat;
F.pval <- pf(q = F.stat, df1 = ncol(X.reduced) - 1, df2 = df.reduced, lower.tail = FALSE);
F.pval;

### (b) ############################################################################################
SS.grand.mean <- sum((DF.data[,'y']-mean(DF.data[,'y']))^2);
R.squared <- 1 - SS.reduced / SS.grand.mean;
R.squared;

adj.R.squared <- 1 - (SS.reduced/df.reduced) / (SS.grand.mean/(nrow(X.reduced)-1));
adj.R.squared;

### (c) ############################################################################################
# 95% confidence interval for beta7 based on reduced model:
c(beta.reduced[2], beta.sd.reduced[2]);
beta.reduced[2] + c(-1,1) * qt(p = 0.025, df = df.reduced, lower.tail = FALSE) * beta.sd.reduced[2];
confint(object = lm.reduced, parm = 'x7', level = 0.95);

# 95% confidence interval for y0 when x7 = 56.0 and x8 = 2100 based on reduced model:
x0     <- matrix(c(1,56,2100),nrow=3,ncol=1);
y0.hat <- as.numeric(t(x0) %*% beta.reduced);
y0.var <- MS.reduced * as.numeric(t(x0) %*% solve(t(X.reduced) %*% X.reduced) %*% x0);
y0.sd  <- sqrt(y0.var);

y0.hat + c(-1,1) * qt(p = 0.025, df = df.reduced, lower.tail = FALSE) * y0.sd;

####################################################################################################

q();

