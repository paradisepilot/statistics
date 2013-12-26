
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

resolution      <- 100;
graphics.format <- 'png';

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.data <- table.b2;
DF.data;

### (a) ############################################################################################
X <- as.matrix(cbind(rep(1,nrow(DF.data)),DF.data[,'x4']));

H    <- X %*% solve(t(X) %*% X) %*% t(X);

diag(H);

yhat <- H %*% DF.data[,'y'];
ordinary.residuals <- DF.data[,'y'] - yhat;

SS.full <- sum(ordinary.residuals^2);
df.full <- nrow(X) - ncol(X);
MS.full <- SS.full / df.full;

standardized.residuals      <- ordinary.residuals / sqrt(MS.full);
studentized.residuals       <- ordinary.residuals / sqrt(MS.full * (1 - diag(H)));
standard.Gaussian.quantiles <- qnorm(p = (1:nrow(DF.data)) / nrow(DF.data));
DF.temp <- data.frame(
	yhat                         = yhat,
	standard.Gaussian.quantile   = standard.Gaussian.quantiles,
	ordinary.residual            = ordinary.residuals,
	standardized.residual        = standardized.residuals,
	studentized.residual         = studentized.residuals,
	ranked.studentized.residual  = sort(studentized.residuals),
	ranked.standardized.residual = sort(standardized.residuals)
	);

my.filename <- paste('problem-04-03-a-standardized',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-2.2,2.2);
my.ggplot <- my.ggplot + ylim(-2.2,2.2);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(x = ranked.standardized.residual, y = standard.Gaussian.quantile)
        );
my.ggplot <- my.ggplot + geom_abline(slope = 1, intercept = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

my.filename <- paste('problem-04-03-a-studentized',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-2.2,2.2);
my.ggplot <- my.ggplot + ylim(-2.2,2.2);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(x = ranked.studentized.residual, y = standard.Gaussian.quantile)
        );
my.ggplot <- my.ggplot + geom_abline(slope = 1, intercept = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

### (b) ############################################################################################
my.filename <- paste('problem-04-03-b-ordinary',graphics.format,sep='.');
my.ggplot <- ggplot();
#my.ggplot <- my.ggplot + xlim(0,12.2);
#my.ggplot <- my.ggplot + ylim(-6.2,6.2);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(y = ordinary.residual, x = yhat)
        );
my.ggplot <- my.ggplot + geom_hline(y = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

my.filename <- paste('problem-04-03-standardized',graphics.format,sep='.');
my.ggplot <- ggplot();
#my.ggplot <- my.ggplot + xlim(0,12.2);
#my.ggplot <- my.ggplot + ylim(-6.2,6.2);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(y = standardized.residual, x = yhat)
        );
my.ggplot <- my.ggplot + geom_hline(y = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

my.filename <- paste('problem-04-03-studentized',graphics.format,sep='.');
my.ggplot <- ggplot();
#my.ggplot <- my.ggplot + xlim(0,12.2);
#my.ggplot <- my.ggplot + ylim(-6.2,6.2);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.temp[1:(nrow(DF.temp)-1),],
        mapping = aes(y = studentized.residual, x = yhat)
        );
my.ggplot <- my.ggplot + geom_hline(y = 0, colour = 'red');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

q();

