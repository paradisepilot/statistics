
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
DF.cases <- data.frame(
	delivery.time.residual = residuals(lm(formula = delivery.time ~ distance, data = DF.data)),
	num.of.cases.residual  = residuals(lm(formula = num.of.cases  ~ distance, data = DF.data))
	);

DF.distance <- data.frame(
	delivery.time.residual = residuals(lm(formula=delivery.time ~ num.of.cases,data=DF.data)),
	distance.residual      = residuals(lm(formula=distance      ~ num.of.cases,data=DF.data))
	);

####################################################################################################
resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('figure-04-07-a',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-12,12);
my.ggplot <- my.ggplot + ylim(-15,15);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.cases,
        mapping = aes(x = num.of.cases.residual, y = delivery.time.residual)
        );
ggsave(file = my.filename, plot = my.ggplot, height = 0.5 * par("din")[1], dpi = resolution, units = 'in');

####################################################################################################
my.filename <- paste('figure-04-07-b',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-400,400);
my.ggplot <- my.ggplot + ylim(-15,15);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.distance,
        mapping = aes(x = distance.residual, y = delivery.time.residual)
        );
ggsave(file = my.filename, plot = my.ggplot, height = 0.5 * par("din")[1], dpi = resolution, units = 'in');

####################################################################################################

q();

