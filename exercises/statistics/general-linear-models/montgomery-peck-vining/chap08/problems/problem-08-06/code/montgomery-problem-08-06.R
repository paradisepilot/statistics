
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
my.pvalue <- function(x = NULL) { return(ifelse(x < 0.5,2*x,2*(1-x))); }

####################################################################################################
library(MPV);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- table.b1;
DF.data <- DF.data[,c('y','x5','x7','x8')];
DF.data[,'x5a'] <- as.factor(
	x = sapply(
		X   = DF.data[,'x5'],
		FUN = function(x) {return(ifelse(x==0,0,x/abs(x)));}
		)
	);

str(DF.data);
DF.data;

####################################################################################################
lm.full <- lm(
	formula = y ~ x5a + x7 + x8,
	data    = DF.data
	);

### manual verification
X <- as.matrix(cbind(
	intercept = rep(1,nrow(DF.data)),
	x5a0 = sapply(X=DF.data[,'x5a'],FUN=function(x){return(ifelse(x==0,1,0))}),
	x5a1 = sapply(X=DF.data[,'x5a'],FUN=function(x){return(ifelse(x==1,1,0))}),
	DF.data[,c('x7','x8')]
	));
X;

y.hat   <- X %*% solve(t(X) %*% X) %*% t(X) %*% DF.data[,'y'];
SS.full <- sum((DF.data[,'y'] - y.hat)^2);
MS.full <- SS.full / (nrow(X) - ncol(X));

ones <- matrix(X[,1],ncol=1);
y.hat.grand.mean <- ones %*% solve(t(ones) %*% ones) %*% t(ones) %*% DF.data[,'y'];
SS.grand.mean <- sum((DF.data[,'y'] - y.hat.grand.mean)^2);

betas.hat    <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'y'];
betas.sd.hat <- sqrt(MS.full * diag(solve(t(X) %*% X)));
t.stats      <- betas.hat / betas.sd.hat;
p.values     <- my.pvalue(pt(q = t.stats, df = nrow(X) - ncol(X)));
cbind(betas = betas.hat, stddev = betas.sd.hat,t.stat = t.stats, pval = p.values);
F.stat <- ((SS.grand.mean - SS.full)/(ncol(X)-1)) / (SS.full/(nrow(X)-ncol(X)))
F.stat;
pf(q = F.stat, df1 = ncol(X)-1, df2 = nrow(X)-ncol(X), lower.tail = FALSE);
1 - SS.full / SS.grand.mean;
1 - (SS.full/(nrow(X)-ncol(X))) / (SS.grand.mean/(nrow(X)-1));
summary(lm.full);

X.reduced <- as.matrix(cbind(intercept = rep(1,nrow(DF.data)), DF.data[,c('x7','x8')]));

y.hat.reduced <- X.reduced %*% solve(t(X.reduced) %*% X.reduced) %*% t(X.reduced) %*% DF.data[,'y'];
SS.reduced <- sum((DF.data[,'y'] - y.hat.reduced)^2);
SS.reduced;

F.stat <- ((SS.reduced - SS.full)/(5-3)) / MS.full;
F.stat;

F.pvalue <- pf(q = F.stat, df1 = 5-3, df2 = nrow(X) - ncol(X), lower.tail = FALSE);
F.pvalue;

lm.reduced <- lm(formula = y ~ x7 + x8, data = DF.data);
anova(lm.reduced,lm.full);

####################################################################################################

q();

