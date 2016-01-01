#!/usr/bin/Rscript

############################################################
command.arguments <- commandArgs(trailingOnly = TRUE);
code.directory    <- normalizePath(command.arguments[1]);
output.directory  <- normalizePath(command.arguments[2]);
tmp.directory     <- normalizePath(command.arguments[3]);

############################################################
setwd(output.directory);

library(yaml);
library(gtrendsR);
library(ggplot2);
library(reshape2);

source(file = paste(code.directory,'my-gtrends.R',sep='/'));

############################################################
gCredentials <- yaml.load_file(input = '~/googleCredentials.yml');
myCurlHandle <- gconnect(
	usr = gCredentials[['username']],
	psw = gCredentials[['password']]
	);

mySearchTerms <- c('Canada','Toronto','Vancouver');

data("countries");
gtrends.results <- my.gtrends(
	ch    = myCurlHandle,
	query = mySearchTerms,
	cat   = "0-67-179"  # "Hotels & Accommodations"
	);
#gtrends.results <- gtrends(
#	ch    = myCurlHandle,
#	query = mySearchTerms,
#	cat   = "Hotels & Accommodations"
#	);
str(gtrends.results);

temp.filename <- paste0(paste(mySearchTerms,collapse='-'),'.csv');
write.table(
	x         = gtrends.results[['trend']],
	file      = temp.filename,
	sep       = "\t",
	quote     = FALSE,
	row.names = FALSE
	);

############################################################
DF.temp <- melt(
	data         = gtrends.results[['trend']],
	id.vars      = c('start'), 
	measure.vars = tolower(mySearchTerms)
	);

temp.filename <- 'myGoogleTrends.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	mapping = aes(x = start, y = value, colour = variable),
	data    = DF.temp
	);
ggsave(file = temp.filename, plot = my.ggplot, dpi = 150, height = 6, width = 12, units = 'in');

############################################################
q();

