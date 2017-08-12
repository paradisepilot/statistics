
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(MPV);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.table(
	file      = paste0(data.directory,'/chap08/examples/data-example-8-1-Tool-Life.csv'),
	row.names = 1,
	header    = TRUE,
	sep       = '\t',
	quote     = ""
	);

colnames(DF.data) <- c('effective.life','revolution.speed','tool.type');

### data correction: downloaded data were differ from those in text.
### here, we correct the downloaded data to those in the text.
DF.data[7,'revolution.speed'] <- 680;

str(DF.data);

####################################################################################################
lm.full <- lm(
	formula = effective.life ~ revolution.speed + tool.type,
	data    = DF.data
	);
summary(lm.full);

### VERIFICATION OF REGRESSION RESULTS #############################################################
X <- cbind(rep(1,nrow(DF.data)),DF.data[,'revolution.speed'],-1+as.integer(DF.data[,'tool.type']));
cbind(X,DF.data[,'effective.life']);

betas <- solve(t(X) %*% X) %*% t(X) %*% DF.data[,'effective.life'];
betas;

sigma2.hat <- sum(residuals(lm.full)^2) / (nrow(DF.data) - 3);
sigma2.hat;

V.beta.hat <- sigma2.hat * solve(t(X) %*% X);
V.beta.hat;
sqrt(diag(V.beta.hat));

### t-test for beta1:
t.stat <- betas[2] / sqrt(diag(V.beta.hat))[2];
t.stat;
2 * pt(q = t.stat, df = nrow(DF.data) - 3, lower.tail = TRUE);

### t-test for beta2:
t.stat <- betas[3] / sqrt(diag(V.beta.hat))[3];
t.stat;
2 * pt(q = t.stat, df = nrow(DF.data) - 3, lower.tail = FALSE);

### confidence interval for beta2:
betas[3] + qt(p = 0.975, df = nrow(DF.data) - 3) * sqrt(diag(V.beta.hat))[3] * c(-1,1);

### VERIFICATION OF ANOVA RESULTS ##################################################################
lm.null <- lm(formula = effective.life ~ 1, data    = DF.data);
anova(lm.null,lm.full);

SS.full <- sum(residuals(lm.full)^2);
SS.full;

SS.grand.mean <- sum((DF.data[,'effective.life'] - mean(DF.data[,'effective.life']))^2);
SS.grand.mean;

MS.full <- SS.full / (nrow(DF.data) - 3);
MS.full;

F.stat <- ((SS.grand.mean - SS.full)/2) / MS.full;
F.stat;

pf(q = F.stat, df1 = 2, df2 = nrow(DF.data) - 3, lower.tail = FALSE);

####################################################################################################

q();

