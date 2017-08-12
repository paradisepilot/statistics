
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(LearnBayes);
library(ggplot2);
library(R2OpenBUGS);
library(coda);

source(paste(code.directory, "bugs-chains.R", sep = "/"));
source(paste(code.directory, "which-bugs.R",  sep = "/"));

data(cancermortality);
str(cancermortality);

####################################################################################################
setwd(output.directory);

####################################################################################################
n <- cancermortality[,'n'];
y <- cancermortality[,'y'];
N <- length(y);

cbind(n,y);

### RUN OpenBUGS ###################################################################################
current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"model-stomach-cancer.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

my.data               <- list("N","n","y");
my.inits              <- function() { return(list(p = rep(0.5,N), alpha = 0.5, beta = 0.5)); }
parameters.to.monitor <- c("p","alpha","beta","Beta.mean","Beta.prec");

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.monitor,
	model.file        = my.model.file,
	n.chains          = 3,
	n.iter            = 5000,
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

my.quantiles <- c(0.05,0.25,0.5,0.75,0.95);

prior.mean <- posterior.sample[,'alpha'] / (posterior.sample[,'alpha'] + posterior.sample[,'beta']);
prior.prec <- posterior.sample[,'alpha'] + posterior.sample[,'beta'];

quantile(x = prior.mean, probs = my.quantiles);
quantile(x = prior.prec, probs = my.quantiles);

temp <- t(apply(
	X      = posterior.sample,
	MARGIN = 2,
	FUN    = function(x) { return(quantile(x=x,probs=my.quantiles));}
	));
temp;

####################################################################################################

q();

