
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

####################################################################################################
setwd(output.directory);

####################################################################################################
p     <- seq(0.05,0.95,0.1);
prior <- c(0.0625,0.125,0.25,0.25,0.125,0.0625,0.03125,0.03125,0.03125,0.03125);
sum(prior);

n <- 27;
y <- 11;  # 11;

### RUN OpenBUGS ###################################################################################
current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"model-proportion.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

my.data               <- list("p","prior","n","y");
my.inits              <- function() { return(list(index = 8)); }
parameters.to.monitor <- c("p.sampled");

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.monitor,
	model.file        = my.model.file,
	n.chains          = 3,
	n.iter            = 10000,
	codaPkg           = TRUE,
	debug             = FALSE,
	useWINE           = TRUE,
	OpenBUGS.pgm      = "/Applications/OpenBUGS/OpenBUGS321/OpenBUGS.exe",
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

summary(posterior.sample[,'p.sampled']);

temp <- table(posterior.sample[,'p.sampled']);
cbind(count = temp, rel.freq = temp/nrow(posterior.sample));

mean(posterior.sample[,'p.sampled'] > 0.5);

####################################################################################################

q();

