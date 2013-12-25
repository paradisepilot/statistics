
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

resolution      <- 100;
graphics.format <- 'png';

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- read.table(
	file      = paste0(data.directory,'/chap02/examples/data-example-2-1-RocketPropellant.csv'),
	header    = TRUE,
	sep       = '\t',
	quote     = ""
	);
str(DF.data);
#DF.data;

####################################################################################################
X <- cbind(rep(1,nrow(DF.data)),as.matrix(DF.data[,'propellant.age']));
H <- X %*% solve(t(X) %*% X) %*% t(X);
str(H);

yhat <- H %*% DF.data[,'shear.strength'];
ordinary.residuals <- DF.data[,'shear.strength']-yhat;

SS.full <- sum((DF.data[,'shear.strength'] - yhat)^2);
df.full <- nrow(X) - ncol(X);
MS.full <- SS.full / (df.full);

studentized.residuals <- ordinary.residuals / sqrt(MS.full * (1-diag(H)));

####################################################################################################
num.of.datapoints <- nrow(DF.data);
empirical.cumulative.probabilities <- (1:num.of.datapoints)/num.of.datapoints;
normal.theoretical.quantiles <- qnorm(p = empirical.cumulative.probabilities, sd = sqrt(MS.full));
DF.temp <- data.frame(
	yhat                             = yhat,
	ordinary.residual                = ordinary.residuals,
	studentized.residual             = studentized.residuals,
	ranked.ordinary.residual         = sort(ordinary.residuals),
	ranked.studentized.residual      = sort(studentized.residuals),
	empirical.cumulative.probability = empirical.cumulative.probabilities,
	normal.theoretical.quantile      = normal.theoretical.quantiles,
	standard.normal.quantile         = qnorm(p = empirical.cumulative.probabilities, sd = 1)
	);
DF.temp;

####################################################################################################
my.filename <- paste('figure-04-11-a',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-260,260);
my.ggplot <- my.ggplot + ylim(-260,260);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(x = ranked.ordinary.residual, y = normal.theoretical.quantile)
        );
my.ggplot <- my.ggplot + geom_abline(slope = 1, intercept = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

my.filename <- paste('figure-04-11-a-studentized',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-2.6,2.6);
my.ggplot <- my.ggplot + ylim(-2.6,2.6);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(x = ranked.studentized.residual, y = standard.normal.quantile)
        );
my.ggplot <- my.ggplot + geom_abline(slope = 1, intercept = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

my.filename <- paste('figure-04-11-b',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(1600,2700);
my.ggplot <- my.ggplot + ylim(-250,250);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp,
        mapping = aes(x = yhat, y = ordinary.residual)
        );
my.ggplot <- my.ggplot + geom_hline(y = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, height = 0.5 * par("din")[1], dpi = resolution, units = 'in');

####################################################################################################
####################################################################################################
DF.data <- DF.data[-c(5,6),];

X <- cbind(rep(1,nrow(DF.data)),as.matrix(DF.data[,'propellant.age']));
H <- X %*% solve(t(X) %*% X) %*% t(X);
str(H);

yhat <- H %*% DF.data[,'shear.strength'];
ordinary.residuals <- DF.data[,'shear.strength']-yhat;

SS.full <- sum((DF.data[,'shear.strength'] - yhat)^2);
df.full <- nrow(X) - ncol(X);
MS.full <- SS.full / (df.full);

studentized.residuals <- ordinary.residuals / sqrt(MS.full * (1-diag(H)));

####################################################################################################
num.of.datapoints <- nrow(DF.data);
empirical.cumulative.probabilities <- (1:num.of.datapoints)/num.of.datapoints;
normal.theoretical.quantiles <- qnorm(p = empirical.cumulative.probabilities, sd = sqrt(MS.full));
DF.temp <- data.frame(
	yhat                             = yhat,
	ordinary.residual                = ordinary.residuals,
	studentized.residual             = studentized.residuals,
	ranked.ordinary.residual         = sort(ordinary.residuals),
	ranked.studentized.residual      = sort(studentized.residuals),
	empirical.cumulative.probability = empirical.cumulative.probabilities,
	normal.theoretical.quantile      = normal.theoretical.quantiles,
	standard.normal.quantile         = qnorm(p = empirical.cumulative.probabilities, sd = 1)
	);
DF.temp;

####################################################################################################
my.filename <- paste('figure-04-12-a',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-260,260);
my.ggplot <- my.ggplot + ylim(-260,260);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(x = ranked.ordinary.residual, y = normal.theoretical.quantile)
        );
my.ggplot <- my.ggplot + geom_abline(slope = 1, intercept = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

my.filename <- paste('figure-04-12-a-studentized',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-2.6,2.6);
my.ggplot <- my.ggplot + ylim(-2.6,2.6);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(x = ranked.studentized.residual, y = standard.normal.quantile)
        );
my.ggplot <- my.ggplot + geom_abline(slope = 1, intercept = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

my.filename <- paste('figure-04-12-b',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(1600,2700);
my.ggplot <- my.ggplot + ylim(-250,250);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp,
        mapping = aes(x = yhat, y = ordinary.residual)
        );
my.ggplot <- my.ggplot + geom_hline(y = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, height = 0.5 * par("din")[1], dpi = resolution, units = 'in');

####################################################################################################

q();

