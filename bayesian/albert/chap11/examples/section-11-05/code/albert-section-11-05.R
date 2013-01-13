
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

rownames(election) <- election[,'county'];
str(election);
rownames(election);

sqrt.buchanan <- sqrt(election[,'buchanan']);
sqrt.perot    <- sqrt(election[,'perot']);

png("buchanan-vs-perot.png");
DF.temp <- data.frame(
	sqrt.perot    = sqrt.perot,
	sqrt.buchanan = sqrt.buchanan
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = sqrt.perot, y = sqrt.buchanan)
	);
my.ggplot;
dev.off();

### RUN OpenBUGS ###################################################################################
Y <- sqrt.buchanan;
X <- sqrt.perot;
N <- length(Y);

current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"model-scale-mixture-normal.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

my.data  <- list ("N","Y","X");
my.inits <- function() { return(list(b = c(0,0),tau = 1)); }
parameters.to.monitor <- c("b","tau");
#parameters.to.monitor <- c("b","tau","lambda");

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.monitor,
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
bugs.results;

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

### ROBUST REGRESSION ##############################################################################
x0 <- 1:200;
T <- cbind(rep(1,length(x0)),x0);

b <- rbind(
	coda.results[[1]][,1:2],
	coda.results[[2]][,1:2],
	coda.results[[3]][,1:2]
	);
str(b);

mean.response.posterior.sample <- T %*% t(b);

mean.response.posterior.interval <- t(apply(
	X      = mean.response.posterior.sample,
	MARGIN = 1,
	FUN    = function(v) {return(quantile(x=v,probs=c(0.05,0.5,0.95)));}
	));
str(mean.response.posterior.interval);

png(filename = "buchanan-vs-perot-regression.png", height = 6, width = 6, units = "in", res = 300);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = data.frame(
		sqrt.perot    = sqrt.perot,
		sqrt.buchanan = sqrt.buchanan
		),
	mapping = aes(x = sqrt.perot, y = sqrt.buchanan)
	);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(
		x = x0,
		y = mean.response.posterior.interval[,1]
		),
	mapping = aes(x = x, y = y),
	colour  = "gray",
	lty     = 2
	);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(
		x = x0,
		y = mean.response.posterior.interval[,2]
		),
	mapping = aes(x = x, y = y),
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_line(
	data    = data.frame(
		x = x0,
		y = mean.response.posterior.interval[,3]
		),
	mapping = aes(x = x, y = y),
	colour  = "gray",
	lty     = 2
	);
my.ggplot;
dev.off();

