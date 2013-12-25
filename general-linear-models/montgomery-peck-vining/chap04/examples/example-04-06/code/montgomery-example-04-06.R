
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

####################################################################################################
X <- cbind(rep(1,nrow(DF.data)),as.matrix(DF.data[,c('num.of.cases','distance')]));
H <- X %*% solve(t(X) %*% X) %*% t(X);
str(H);

yhat <- H %*% DF.data[,'delivery.time'];

ordinary.residuals <- DF.data[,'delivery.time']-yhat;
PRESS.residuals    <- ordinary.residuals/(1-diag(H));
DF.temp <- cbind(ordinary.residuals,diag(H),PRESS.residuals,(PRESS.residuals)^2);
DF.temp;

PRESS <- sum(DF.temp[,4]);
PRESS;

SS.grand.mean <- sum((DF.data[,'delivery.time']-mean(DF.data[,'delivery.time']))^2);
SS.grand.mean;

1 - PRESS / SS.grand.mean;

####################################################################################################

q();

