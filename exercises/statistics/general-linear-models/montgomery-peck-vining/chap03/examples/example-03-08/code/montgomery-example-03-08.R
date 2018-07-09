
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

### VERIFICATION OF REGRESSION RESULTS #############################################################
X.full    <- cbind(rep(1,nrow(DF.data)),DF.data[,'num.of.cases'],DF.data[,'distance']);

beta.full    <- solve(t(X.full) %*% X.full) %*% t(X.full) %*% DF.data[,'delivery.time'];
yhat.full    <- X.full %*% beta.full;
SS.full      <- sum((DF.data[,'delivery.time']-yhat.full)^2);
df.full      <- nrow(DF.data) - ncol(X.full);
MS.full      <- SS.full / df.full;
beta.sd.full <- sqrt(diag(MS.full * solve(t(X.full) %*% X.full)));
t.stat.full  <- beta.full / beta.sd.full;
pvalue.full  <- my.pvalue(pt(q = t.stat.full, df = df.full));

cbind(beta.full,beta.sd.full,t.stat.full,pvalue.full);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~
### using R build-in functions:
summary(lm.full);

### 95% confidence interval for beta1:
qt(p = 0.025, df = df.full, lower.tail = FALSE);
beta.full[2] + qt(p = 0.025, df = df.full, lower.tail = FALSE) * beta.sd.full[2] * c(-1,1);

q();

