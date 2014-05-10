
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

####################################################################################################
library(ggplot2);
#library(foreign);
#source(paste0(code.directory,'/hiv-immunization.R'));

resolution <- 300;

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.unicef.raw <- read.table(
	file       = '~/Work/github/paradisepilot/statistics/projects/DataForGood/2014-05-10/UNICEF/combine-tables/output/unicef-raw-data.csv',
	header     = TRUE,
	sep        = ",",
	quote      = "",
	stringsAsFactors = FALSE
	);
str(DF.unicef.raw[,  1: 80]);
str(DF.unicef.raw[, 81:160]);
str(DF.unicef.raw[,171:197]);

####################################################################################################
selected.colnames <- grep(x = colnames(DF.unicef.raw), pattern = 'immunization', value = TRUE);
selected.colnames;

####################################################################################################

q();

####################################################################################################
temp.filename <- '.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = BCG, y = adult.hiv.prevalence.percent.2011)
	);
my.ggplot <- my.ggplot + xlab("BCG (2011)");
my.ggplot <- my.ggplot + ylab("adult HIV prevalence (%), 2011");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 25), axis.text  = element_text(size = 25));
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,100));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

