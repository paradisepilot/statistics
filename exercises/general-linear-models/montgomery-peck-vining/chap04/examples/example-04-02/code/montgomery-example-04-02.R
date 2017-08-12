
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

####################################################################################################
H.full                      <- X.full %*% solve(t(X.full) %*% X.full) %*% t(X.full);
usual.residuals             <- DF.data[,'delivery.time'] - yhat.full;
studentized.residuals       <- usual.residuals / sqrt(MS.full*(1-diag(H.full))) ;
cumulative.probabilities    <- (1:nrow(DF.data)-0.5)/nrow(DF.data);
expected.Gaussian.quantiles <- qnorm(p = cumulative.probabilities);
DF.residuals <- as.data.frame(cbind(
	cumulative.probabilities,
	expected.Gaussian.quantiles,
	sort(usual.residuals),
	sort(studentized.residuals)
	));
colnames(DF.residuals) <- c(
	'cumulative.prob',
	'expected.Gaussian.quantile',
	'ranked.residual',
	'ranked.studentized.residual'
	);
DF.residuals;

####################################################################################################
resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('figure-04-02-a',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-8,8);
my.ggplot <- my.ggplot + ylim(0,1);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.residuals,
        mapping = aes(x = ranked.residual, y = cumulative.prob)
        );
my.ggplot <- my.ggplot + geom_smooth(
        data    = DF.residuals,
        mapping = aes(x = ranked.residual, y = cumulative.prob),
	method  = 'lm',
	se      = FALSE,
	colour  = 'red'
	);
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

####################################################################################################
resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('qqplot-ranked-ordinary-residuals',graphics.format,sep='.');
my.ggplot <- ggplot();
#my.ggplot <- my.ggplot + xlim(-8,8);
#my.ggplot <- my.ggplot + ylim(0,40);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.residuals,
        mapping = aes(x = ranked.residual, y = expected.Gaussian.quantile)
        );
my.ggplot <- my.ggplot + geom_smooth(
	data    = DF.residuals,
        mapping = aes(x = ranked.residual, y = expected.Gaussian.quantile),
	method  = 'lm',
	se      = FALSE,
	colour  = 'red'
	);
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

####################################################################################################
my.filename <- paste('figure-04-02-b',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-3,4);
my.ggplot <- my.ggplot + ylim(0,1);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.residuals,
        mapping = aes(x = ranked.studentized.residual, y = cumulative.prob)
        );
my.ggplot <- my.ggplot + geom_smooth(
        data    = DF.residuals,
        mapping = aes(x = ranked.studentized.residual, y = cumulative.prob),
	method  = 'lm',
	se      = FALSE,
	colour  = 'red'
	);
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

####################################################################################################
resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('qqplot-ranked-studentized-residuals',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + xlim(-2.5,2.5);
my.ggplot <- my.ggplot + ylim(-2.5,2.5);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.residuals,
        mapping = aes(x = ranked.studentized.residual, y = expected.Gaussian.quantile)
        );
my.ggplot <- my.ggplot + geom_smooth(
	data    = DF.residuals,
        mapping = aes(x = ranked.studentized.residual, y = expected.Gaussian.quantile),
	method  = 'lm',
	se      = FALSE,
	colour  = 'red'
	);
my.ggplot <- my.ggplot + geom_abline(intercept = 0, slope = 1, colour = 'gray');
ggsave(file = my.filename, plot = my.ggplot, dpi = resolution, units = 'in');

####################################################################################################

q();

