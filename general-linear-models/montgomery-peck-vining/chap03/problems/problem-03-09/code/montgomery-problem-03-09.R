
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
DF.data <- table.b6;
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^y$', replacement='NbOCl3');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x1$',replacement='COCl2');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x2$',replacement='time');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x3$',replacement='molar.density');
colnames(DF.data) <- gsub(x=colnames(DF.data),pattern='^x4$',replacement='mole.fraction');

str(DF.data);
DF.data;

lm.full <- lm(formula = NbOCl3 ~ COCl2 + time + molar.density + mole.fraction, data = DF.data);
summary(lm.full);
faraway::vif(lm.full);

####################
lm.reduced <- lm(formula = NbOCl3 ~ COCl2 + time + mole.fraction, data = DF.data);
summary(lm.reduced);
anova(lm.reduced,lm.full);
faraway::vif(lm.reduced);

####################
lm.reduced <- lm(formula = NbOCl3 ~ COCl2 + molar.density + mole.fraction, data = DF.data);
summary(lm.reduced);
anova(lm.reduced,lm.full);
faraway::vif(lm.reduced);

####################
lm.reduced <- lm(formula = NbOCl3 ~ COCl2 + time + molar.density, data = DF.data);
summary(lm.reduced);
anova(lm.reduced,lm.full);
faraway::vif(lm.reduced);

####################
lm.reduced <- lm(formula = NbOCl3 ~ COCl2 + time, data = DF.data);
summary(lm.reduced);
anova(lm.reduced,lm.full);
faraway::vif(lm.reduced);

####################
# The above observations suggest that the "best" model should be:
# NbOCl3 ~ COCl2 + molar.density + mole.fraction

### (a) ############################################################################################
X.full       <- as.matrix(cbind(intercept=rep(1,nrow(DF.data)),DF.data[,c('COCl2','mole.fraction')]));
beta.full    <- solve(t(X.full) %*% X.full) %*% t(X.full) %*% DF.data[,'NbOCl3'];
yhat.full    <- X.full %*% beta.full;
SS.full      <- sum((DF.data[,'NbOCl3']-yhat.full)^2);
df.full      <- nrow(X.full) - ncol(X.full);
MS.full      <- SS.full / df.full;
beta.sd.full <- sqrt(MS.full * diag(solve(t(X.full) %*% X.full)));
t.stats      <- beta.full / beta.sd.full;
pvalues      <- my.pvalue(pt(q = t.stats, df = df.full));

SS.grand.mean <- sum((DF.data[,'NbOCl3'] - mean(DF.data[,'NbOCl3']))^2);
MS.grand.mean <- SS.grand.mean / (nrow(X.full) - 1);
R.squared <- 1 - SS.full / SS.grand.mean;
adj.R.squared <- 1 - MS.full / MS.grand.mean;

F.stat <- (sum((yhat.full-mean(DF.data[,'NbOCl3']))^2) / (ncol(X.full)-1)) / MS.full;
F.pval <- pf(q = F.stat, df1 = ncol(X.full)-1, df2 = df.full, lower.tail = FALSE);

cbind(beta.full,beta.sd.full,t.stats,pvalues);
c(R.squared,adj.R.squared);
c(F.stat,F.pval);

### ~~~~~~~~~~
### The following shows that once COCl2 is included in the model, mole.fraction adds little
### additional explanatory power for NbOCl3.
lm.a <- lm(formula = NbOCl3 ~ COCl2 + mole.fraction, data = DF.data);
summary(lm.a);
faraway::vif(lm.a);

### ~~~~~~~~~~
### The following shows that, among COCl2 and mole.fraction, COCl2 is the important predictor
### variable, whereas mole.fraction is not.
summary(lm(formula = NbOCl3 ~ COCl2,         data = DF.data));
summary(lm(formula = NbOCl3 ~ mole.fraction, data = DF.data));

### (b) ############################################################################################
# The regression is significant.
c(F.stat,F.pval);

### (c) ############################################################################################
c(R.squared,adj.R.squared);

### (d) ############################################################################################
# COCl2 gives significant contribution to explaining the response variable NbOCl3.
# mole fraction does NOT give significant contribution.
cbind(beta.full,beta.sd.full,t.stats,pvalues);

### (e) ############################################################################################
# No, multicollinearity should not be a potential concern.

q();

