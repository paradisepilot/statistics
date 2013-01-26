
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

### DATA & SIMULATION INITIALIZATION ###############################################################
sigma <- 5;

THM.observed   <- c(128, 132);
n.observations <- length(THM.observed);

prior.mean  <- 120;
prior.sigma <-  10;

my.data               <- list("sigma","THM.observed","n.observations","prior.mean","prior.sigma");
my.inits              <- function() { return(list(mortality.rate = 0.1)); }
parameters.to.monitor <- c("THM.mean");

### SET OUTPUT DIRECTORY ###########################################################################
setwd(output.directory);

### RUN OpenBUGS ###################################################################################
current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"probabilistic-model.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.monitor,
	model.file        = my.model.file,
	n.chains          = 3,
	n.iter            = 1e+5,
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

