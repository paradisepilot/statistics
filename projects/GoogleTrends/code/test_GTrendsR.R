
############################################################
# library(devtools);
# devtools::install_github("dvanclev/GTrendsR");

command.arguments <- commandArgs(trailingOnly = TRUE);
code.directory    <- normalizePath(command.arguments[1]);
output.directory  <- normalizePath(command.arguments[2]);
tmp.directory     <- normalizePath(command.arguments[3]);

############################################################
setwd(output.directory);

############################################################
library(yaml);
library(GTrendsR);

gCredentials <- yaml.load_file(input = '~/googleCredentials.yml');

myCurlHandle <- gconnect(
	usr = gCredentials[['username']],
	psw = gCredentials[['password']]
	);

gtrends.results <- gtrends(
	ch    = myCurlHandle,
	query = c('free shipping'),
	geo   = "all",
	cat   = "0"
	);

str(gtrends.results);

png(file = "myplot.png", width = 2 * 480, height = 480);
plot(
	x    = gtrends.results[['trend']][['start']],
	y    = gtrends.results[['trend']][['free.shipping']],
	type = "l"
	);
dev.off();

