
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
DF.data <- read.table(
	file      = paste0(data.directory,'/chap03/examples/data-example-3-1-DeliveryTime.csv'),
	row.names = 1,
	header    = TRUE,
	sep       = '\t',
	quote     = ""
	);
str(DF.data);
#DF.data;

### data correction: downloaded data were differ from those in text.
### here, we correct the downloaded data to those in the text.
#DF.data[7,'revolution.speed'] <- 680;

####################################################################################################
lm.full <- lm(
	formula = delivery.time ~ num.of.cases + distance,
	data    = DF.data
	);

lm.reduced <- lm(
	formula = delivery.time ~ num.of.cases,
	data    = DF.data
	);

### VERIFICATION OF REGRESSION RESULTS #############################################################
X.full    <- cbind(rep(1,nrow(DF.data)),DF.data[,'num.of.cases'],DF.data[,'distance']);
X.reduced <- cbind(rep(1,nrow(DF.data)),DF.data[,'num.of.cases']);

beta.full    <- solve(t(X.full) %*% X.full) %*% t(X.full) %*% DF.data[,'delivery.time'];
yhat.full    <- X.full %*% beta.full;
SS.full      <- sum((DF.data[,'delivery.time']-yhat.full)^2);
df.full      <- nrow(DF.data) - ncol(X.full);
MS.full      <- SS.full / df.full;
beta.sd.full <- sqrt(diag(MS.full * solve(t(X.full) %*% X.full)));
t.stat.full  <- beta.full / beta.sd.full;
pvalue.full  <- my.pvalue(pt(q = t.stat.full, df = df.full));

beta.reduced <- solve(t(X.reduced) %*% X.reduced) %*% t(X.reduced) %*% DF.data[,'delivery.time'];
yhat.reduced <- X.reduced %*% beta.reduced;
SS.reduced   <- sum((DF.data[,'delivery.time']-yhat.reduced)^2);

cbind(beta.full,beta.sd.full,t.stat.full,pvalue.full);
ss01    <- sum(yhat.full^2) - sum(yhat.reduced^2);
df01    <- ncol(X.full) - ncol(X.reduced);
ms01    <- ss01 / df01;
fstat01 <- ms01 / MS.full;
pv01    <- pf(q = fstat01, df1 = df01, df2 = nrow(X.full) - ncol(X.full), lower.tail = FALSE);
c(ss01,df01,ms01,fstat01,pv01);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~
### using R build-in functions:
summary(lm.full);
anova(lm.reduced,lm.full);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sum((yhat.full - yhat.reduced)^2);
sum(yhat.full^2) - sum(yhat.reduced^2);
SS.reduced - SS.full;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### comparing t-stat and F-stat:
beta.full[3];
beta.full[3]^2;
beta.full[3]^2 / solve(t(X.full) %*% X.full)[3,3];

# numerator of F-statistic (degree of freedom = 1)
ss01 <- sum(yhat.full^2) - sum(yhat.reduced^2);
ss01;

q();

