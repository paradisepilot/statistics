
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

N  <- 80;
Y  <- 10;

my.data               <- list("N","Y");
my.inits              <- function() { return(list(p = 0.5)); }
parameters.to.monitor <- c("p");

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.monitor,
	model.file        = my.model.file,
	n.chains          = 3,
	n.iter            = 100000,
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

