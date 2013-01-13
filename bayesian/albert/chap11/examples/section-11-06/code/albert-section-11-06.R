
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

data(sluggerdata);
str(sluggerdata);

### RUN OpenBUGS ###################################################################################
temp <- careertraj.setup(sluggerdata);
N <- temp[['N']];
T <- temp[['T']];
y <- temp[['y']];
n <- temp[['n']];
x <- temp[['x']];

# parameters for the prior distributions of the hyperparameters
mu.beta.mean      <- c(0,0,0);
mu.beta.precision <- diag(rep(1e-6,3));
Scale.Matrix      <- diag(rep(0.1,3));

current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"model-home-run-rate.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

my.data  <- list ("N","T","y","n","x","mu.beta.mean","mu.beta.precision","Scale.Matrix");
my.inits <- function() {
	return(
		list(
			beta    = matrix(c(-7.69,0.35,-0.0058),nrow=10,ncol=3,byrow=TRUE),
			mu.beta = c(-7.69,0.35,-0.0058),
			R       = diag(rep(0.1,3))
			)
		);
	}

parameters.to.monitor <- c("beta");
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

q();

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

