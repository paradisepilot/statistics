
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

####################################################################################################
class(coda.results[[1]]);
str(coda.results[[1]]);

DF.beta <- rbind(
	as.data.frame(coda.results[[1]]),
	as.data.frame(coda.results[[2]]),
	as.data.frame(coda.results[[3]])
	);
str(DF.beta);

last.names <- c(
	'Aaron',   'Greenberg', 'Killebrew', 'Mantle',  'Mays',
	'McCovey', 'Ott',       'Ruth',      'Schmidt', 'Sosa'
	);

DF.quantiles <- as.data.frame(matrix(nrow=10,ncol=5));
rownames(DF.quantiles) <- last.names;
colnames(DF.quantiles) <- c('2.5%','25%','50%','75%','98%');

for (i in 1:10) {

	last.name <- last.names[i];

	selected.colnames <- paste(paste(paste('beta[',i,',',sep=""),1:3,sep=""),']',sep="");
	print("selected.colnames");
	print( selected.colnames );
	DF.temp <- DF.beta[,selected.colnames];
	print("str(DF.temp)");
	print( str(DF.temp) );
	DF.temp[,'peak.age'] <- -DF.temp[,2]/2/DF.temp[,3];
	DF.quantiles[last.name,] <- quantile(
		x     = DF.temp[,'peak.age'],
		probs = c(0.025,0.25,0.5,0.75,0.98)
		);

	png(paste(last.name,".png",sep=""));
	my.ggplot <- ggplot(data = NULL);
	my.ggplot <- my.ggplot + geom_density(
		data    = DF.temp,
		mapping = aes(x = peak.age)
		);
	my.ggplot <- my.ggplot + labs(title = last.name);
	print(my.ggplot);
	dev.off();

	}

DF.quantiles;

q();

