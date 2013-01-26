
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(ggplot2);
library(R2OpenBUGS);
library(coda);

source(paste(code.directory, "bugs-chains.R", sep = "/"));
source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
Y <- 1;

### SET OUTPUT DIRECTORY ###########################################################################
setwd(output.directory);

### RUN OpenBUGS ###################################################################################
current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"probabilistic-model.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

Test        <- 1;
prevalence  <- 1/1000;
sensitivity <- 0.95;
specificity <- 0.98;

my.data               <- list("Test","prevalence","sensitivity","specificity");
my.inits              <- function() { return(list(HIV = 0)); }
parameters.to.monitor <- c("HIV","positive.rate");

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.monitor,
	model.file        = my.model.file,
	n.chains          = 3,
	n.iter            = 1e+6,
	codaPkg           = TRUE,
	debug             = FALSE,
	useWINE           = which.bugs()[['use.wine']],
	OpenBUGS.pgm      = which.bugs()[['bugs.path']],
	working.directory = tmp.directory
	);
str(bugs.results);

### DIAGNOSTICS USING coda #########################################################################
coda.results <- read.bugs(bugs.results);

str(coda.results);
summary(coda.results);

png("trace-plots.png");
xyplot(coda.results);
dev.off();

png("autocorrelation-plots.png");
acfplot(coda.results);
dev.off();

png("density-plots.png");
densityplot(coda.results);
dev.off();

####################################################################################################
posterior.sample <- bugs.chains(input.mcmc.list = coda.results);
str(posterior.sample);

my.quantiles <- c(0.05,0.5,0.95);

temp <- t(apply(
	X      = posterior.sample,
	MARGIN = 2,
	FUN    = function(x) { return(c(post.mean=mean(x),post.sd=sd(x),quantile(x=x,probs=my.quantiles))); }
	));
temp;

####################################################################################################

q();

