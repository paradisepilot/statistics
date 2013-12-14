
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

### (a), (c) #######################################################################################
DF.data <- table.b1;
DF.data <- DF.data[,c('y','x2','x7','x8')];
lm.full <- lm(formula = y ~ x2 + x7 + x8, data = DF.data);

str(DF.data);
DF.data;

X <- as.matrix(cbind(intercept = rep(1,nrow(DF.data)),DF.data[,c('x2','x7','x8')]));
betas    <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'y'];
y.hat    <- X %*% betas;
SS.full  <- sum((DF.data[,'y']-y.hat)^2);
MS.full  <- SS.full / (nrow(X) - ncol(X));
betas.sd <- sqrt(MS.full * diag(solve(t(X) %*% X)));
t.stats  <- betas / betas.sd;
pvalues  <- my.pvalue(pt(q = t.stats, df = nrow(X) - ncol(X)));

cbind(betas,betas.sd,t.stats,pvalues);
summary(lm.full);

### (b) ############################################################################################
SS.grand.mean <- sum((DF.data[,'y']-mean(DF.data[,'y']))^2);
F.stat <- ((SS.grand.mean - SS.full)/(ncol(X)-1)) / (MS.full);
F.stat;
pf(q = F.stat, df1 = ncol(X)-1, df2 = nrow(X)-ncol(X), lower.tail = FALSE);

### (d) ############################################################################################
1 - SS.full / SS.grand.mean;
1 - (SS.full/(nrow(X)-ncol(X))) / (SS.grand.mean/(nrow(X)-1));

### (e) ############################################################################################
X.reduced  <- as.matrix(cbind(intercept = rep(1,nrow(DF.data)),DF.data[,c('x2','x8')]));
betas      <- solve(t(X.reduced) %*% X.reduced) %*% t(X.reduced) %*% DF.data[,'y'];
y.hat      <- X.reduced %*% betas;
SS.reduced <- sum((DF.data[,'y']-y.hat)^2);
F.stat     <- ((SS.reduced - SS.full)/(1)) / (MS.full);
F.stat;
pf(q = F.stat, df1 = 1, df2 = nrow(X)-ncol(X), lower.tail = FALSE);

lm.reduced <- lm(formula = y ~ x2 + x8, data = DF.data);
anova(lm.reduced,lm.full);

####################################################################################################

q();

