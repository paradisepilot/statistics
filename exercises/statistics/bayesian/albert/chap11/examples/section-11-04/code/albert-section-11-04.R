
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(LearnBayes);
library(ggplot2);
library(R2OpenBUGS);
library(coda);

####################################################################################################
setwd(output.directory);

Y <- c(
	4,5,4,1,0,4,3,4,0,6,
	3,3,4,0,2,6,3,3,5,4,
	5,3,1,4,4,1,5,5,3,4,
	2,5,2,2,3,4,2,1,3,2,
	1,1,1,1,1,3,0,0,1,0,
	1,1,0,0,3,1,0,3,2,2,
	0,1,1,1,0,1,0,1,0,0,
	0,2,1,0,0,0,1,1,0,2,
	2,3,1,1,2,1,1,1,1,2,
	4,2,0,0,0,1,4,0,0,0,
	1,0,0,0,0,0,1,0,0,1,
	0,0
	);

N <- length(Y);

#cbind(1:N,Y);

png("coal-mine-disasters.png");
DF.temp <- data.frame(
	year            = 1850 + 1:length(Y),
	num.of.disaster = Y
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = year, y = num.of.disaster)
	);
my.ggplot;
dev.off();

### RUN OpenBUGS ###################################################################################
current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"model-change-point.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

my.data  <- list ("N","Y");
my.inits <- function() { return(list(b = c(0,0), changeyear = 50)); }

parameters.to.simulate <- c("changeyear","b");

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.simulate,
	model.file        = my.model.file,
	n.chains          = 3,
	n.iter            = 5000,
	codaPkg           = TRUE,
	#debug             = TRUE,
	debug             = FALSE,
	useWINE           = TRUE,
	OpenBUGS.pgm      = "/Applications/OpenBUGS/OpenBUGS321/OpenBUGS.exe",
	working.directory = tmp.directory
	);
str(bugs.results)

#png("bugs-results.png");
#plot(bugs.results)
#dev.off();

### DIAGNOSTICS USING coda #########################################################################
coda.results <- read.bugs(bugs.results);

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

