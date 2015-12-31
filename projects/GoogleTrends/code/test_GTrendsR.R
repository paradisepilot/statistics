
############################################################
command.arguments <- commandArgs(trailingOnly = TRUE);
code.directory    <- normalizePath(command.arguments[1]);
output.directory  <- normalizePath(command.arguments[2]);
tmp.directory     <- normalizePath(command.arguments[3]);

############################################################
setwd(output.directory);

############################################################
library(yaml);
library(gtrendsR);
library(ggplot2);
library(reshape2);

gCredentials <- yaml.load_file(input = '~/googleCredentials.yml');

############################################################
myCurlHandle <- gconnect(
	usr = gCredentials[['username']],
	psw = gCredentials[['password']]
	);

data("countries");
gtrends.results <- gtrends(
	ch    = myCurlHandle,
	query = c('free shipping','christmas tree')
	);
str(gtrends.results);

############################################################
DF.temp <- melt(
	data         = gtrends.results[['trend']][,c('start','free.shipping','christmas.tree')],
	id.vars      = c('start'), 
	measure.vars = c('free.shipping','christmas.tree')
	);

summary(DF.temp);
print(DF.temp);

############################################################
my.ggplot <- ggplot(data = NULL);

my.ggplot <- my.ggplot + geom_line(
	mapping = aes(x = start, y = value, colour = variable),
	data    = DF.temp
	);

temp.filename <- 'myGoogleTrends.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = 150, height = 6, width = 12, units = 'in');

############################################################
q();

