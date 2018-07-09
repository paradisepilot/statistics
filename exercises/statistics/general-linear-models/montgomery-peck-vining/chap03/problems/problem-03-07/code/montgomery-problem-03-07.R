
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
DF.data <- table.b4;
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^y$', replacement='price');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x1$',replacement='taxes');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x2$',replacement='n.baths');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x3$',replacement='lot.size');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x4$',replacement='lvng.spc');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x5$',replacement='n.garage');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x6$',replacement='n.rms');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x7$',replacement='n.bdrms');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x8$',replacement='age');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x9$',replacement='n.frpls');

str(DF.data);
DF.data;

lm.full <- lm(
	formula = price ~ taxes + n.baths + lot.size + lvng.spc + n.garage + n.rms + n.bdrms + age + n.frpls,
	data = DF.data
	);

### (a) ############################################################################################
# fitting full model (with all predictor variables)
X.full       <- as.matrix(cbind(intercept = rep(1,nrow(DF.data)),DF.data[,setdiff(colnames(DF.data),'price')]));
beta.full    <- solve(t(X.full) %*% X.full) %*% t(X.full) %*% DF.data[,'price'];
yhat.full    <- X.full %*% beta.full;
SS.full      <- sum((DF.data[,'price']-yhat.full)^2);
df.full      <- nrow(X.full) - ncol(X.full);
MS.full      <- SS.full / df.full;
beta.sd.full <- sqrt(MS.full * diag(solve(t(X.full) %*% X.full)));
t.stats      <- beta.full / beta.sd.full;
pvalues      <- my.pvalue(pt(q = t.stats, df = df.full));

SS.grand.mean <- sum((DF.data[,'price'] - mean(DF.data[,'price']))^2);
MS.grand.mean <- SS.grand.mean / (nrow(X.full) - 1);
R.squared <- 1 - SS.full / SS.grand.mean;
adj.R.squared <- 1 - MS.full / MS.grand.mean;

F.stat <- (sum((yhat.full-mean(DF.data[,'price']))^2) / (ncol(X.full)-1)) / MS.full;
F.pval <- pf(q = F.stat, df1 = ncol(X.full)-1, df2 = df.full, lower.tail = FALSE);

cbind(beta.full,beta.sd.full,t.stats,pvalues);
c(R.squared,adj.R.squared);
c(F.stat,F.pval);

summary(lm.full);

### (b) ############################################################################################
# perform F-test (comparing full model against grand-mean model)

F.stat <- (sum((yhat.full-mean(DF.data[,'price']))^2) / (ncol(X.full)-1)) / MS.full;
F.pval <- pf(q = F.stat, df1 = ncol(X.full)-1, df2 = df.full, lower.tail = FALSE);
c(F.stat,F.pval);

####################################################################################################
# Observation:
# Let p1 be the p-value of the T-test for the estimator of a coefficient corresponding to a certain
# predictor variable.
# Let p2 be the p-value of the F-test when comparing the full model with the reduced model obtained
# from the full model by omitting that predictor variable.
# Then, p1 = p2.
# Example: We omit the predictor variable n.garage below. Note that the p-values of the
# corresponding T-test and F-test are equal.

lm.reduced <- lm(
	formula = price ~ taxes + n.baths + lot.size + lvng.spc + n.rms + n.bdrms + age + n.frpls,
	data = DF.data
	);
anova(lm.reduced,lm.full);
coef(summary(lm.full))['n.garage',];
coef(summary(lm.full))['n.garage','t value'];
coef(summary(lm.full))['n.garage','t value']^2;

### (c) ############################################################################################
# The p-value of each of the predictor variables except 'taxes' is above 0.1. So, we may conclude
# that each of these (non-taxes) predictor variables X individually, does NOT significantly improve
# upon the model that contains all the rest of the predictor variables but not X.
# The variable 'taxes' has p-value 0.0827, and is thus mildly significant.

### (d) ############################################################################################
lm.reduced <- lm(
	formula = price ~ taxes + n.baths + n.garage + n.rms + n.bdrms + age + n.frpls,
	data = DF.data
	);
anova(lm.reduced,lm.full);

# The contribution of living space and lot size, given that the rest of the predictor variable are
# already in the model, is NOT significant.

### (e) ############################################################################################
# The F-test in part (b) yielded the conclusion that the nine predictor variables together give
# significant improvement in explaining the response variable 'price' when compared to the grand
# mean model. However, the individual t-tests for each of the predictor variables gave
# non-significant results. This suggests that there might be non-trivial multicollinearity among
# the nine predictor variables.

library(faraway);

vif(lm.full);

lm.temp <- lm(formula = price ~ taxes+n.baths+lot.size+lvng.spc+n.garage+n.bdrms+age+n.frpls, data = DF.data);
vif(lm.temp);
summary(lm.temp);

lm.temp <- lm(formula = price ~ n.baths+lot.size+lvng.spc+n.garage+n.bdrms+age+n.frpls, data = DF.data);
vif(lm.temp);
summary(lm.temp);

lm.temp <- lm(formula = price ~ n.baths+lot.size+n.garage+n.bdrms+age+n.frpls, data = DF.data);
vif(lm.temp);
summary(lm.temp);

lm.temp <- lm(formula = price ~ n.baths+lot.size+n.garage+age+n.frpls, data = DF.data);
vif(lm.temp);
summary(lm.temp);

####################################################################################################

q();

