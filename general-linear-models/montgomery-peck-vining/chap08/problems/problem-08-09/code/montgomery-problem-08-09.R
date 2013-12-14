
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
group.sizes <- c(3,2,4,3);

DF.data <- data.frame(
	y     = rnorm(sum(group.sizes)),
	group = c(rep('A',3),rep('B',2),rep('C',4),rep('D',3))
	);
str(DF.data);
DF.data;

lm.results <- lm(formula = y ~ group, data = DF.data);

X <- cbind(
	rep(1,nrow(DF.data)),
	generate.indicator(x = DF.data[,'group'], label = 'B'),
	generate.indicator(x = DF.data[,'group'], label = 'C'),
	generate.indicator(x = DF.data[,'group'], label = 'D')
	);
X;

model.matrix(lm.results);

betas <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'y'];
y.hat <- X %*% betas;
SS.full <- sum((DF.data[,'y']-y.hat)^2);
MS.full <- SS.full / (nrow(X) - ncol(X)) ;
betas.sd <- sqrt(diag(MS.full * solve(t(X) %*% X)));
t.stats  <- betas / betas.sd;
pvalues  <- my.pvalue(pt(q = t.stats, df = nrow(X) - ncol(X)));
cbind(betas,betas.sd,t.stats,pvalues);
summary(lm.results);

SS.grand.mean <- sum((DF.data[,'y'] - mean(DF.data[,'y']))^2)
1 - SS.full / SS.grand.mean;
1 - (SS.full/(nrow(X)-ncol(X))) / (SS.grand.mean/(nrow(X)-1));

F.stat <- ((SS.grand.mean - SS.full)/(ncol(X)-1)) / (MS.full);
F.stat;
pf(q = F.stat, df1 = ncol(X) - 1, df2 = nrow(X) - ncol(X), lower.tail = FALSE);

anova(lm.results);

####################################################################################################

q();

