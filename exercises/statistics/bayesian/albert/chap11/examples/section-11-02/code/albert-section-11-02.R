
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(R2OpenBUGS);

####################################################################################################
setwd(output.directory);

current.directory <- getwd();
setwd(code.directory);
my.model.file <- paste(getwd(),"model-binomial-beta.txt",sep="/");
setwd(current.directory);

my.model.file;
file.show(my.model.file);

my.data <- list (
	y     = 7,
	n     = 50,
	alpha = 0.5,
	beta  = 0.5
	);

my.inits <- function() { return(list(p = 0.1)); }

parameters.to.simulate <- c("p")

bugs.results <- bugs(
	data              = my.data,
	inits             = my.inits,
	parameters        = parameters.to.simulate,
	model.file        = my.model.file,
	n.chains          = 3,
	n.iter            = 5000,
	debug             = FALSE,  # TRUE,
	useWINE           = TRUE,
	OpenBUGS.pgm      = "/Applications/OpenBUGS/OpenBUGS321/OpenBUGS.exe",
	working.directory = tmp.directory
	);
str(bugs.results)

png("bugs-results.png");
plot(bugs.results)
dev.off();

