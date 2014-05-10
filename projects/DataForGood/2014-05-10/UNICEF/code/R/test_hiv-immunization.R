
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

reset.pt1 <- function(input = NULL) {
	output <- gsub(
		x           = input,
		pattern     = "<0.1",
		replacement = "0.1"
		);
	return(as.numeric(output));
	}

remove.space <- function(input = NULL) {
	output <- gsub(
		x           = input,
		pattern     = " ",
		replacement = ""
		);
	return(as.integer(output));
	}

cleanup.country.names <- function(input = NULL) {
	output <- input;
	output <- gsub(x = output, pattern = "Bolivia \\(Plurinational State of\\)", replacement = "Bolivia");
	output <- gsub(x = output, pattern = "Côte d'Ivoire", replacement = "Cote dIvoire");
	output <- gsub(x = output, pattern = "Democratic People's Republic of Korea", replacement = "Democratic People Republic of Korea");
	output <- gsub(x = output, pattern = "Lao People's Democratic Republic", replacement = "Lao People Democratic Republic");
	output <- gsub(x = output, pattern = "South Sudan", replacement = "Republic of South Sudan");
	output <- gsub(x = output, pattern = "United Kingdom of Great Britain and Northern Ireland", replacement = "United Kingdom");
	output <- gsub(x = output, pattern = "Venezuela \\(Bolivarian Republic of\\)", replacement = "Venezuela");
	output <- gsub(x = output, pattern = "Sao Tome and Principe", replacement = "São Tomé and Príncipe");
	return(output);
	}

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.immunization <- read.table(
	file       = paste0(data.directory,'/Immunization_Coverage_2012.csv'),
	header     = TRUE,
	#na.strings = "…",
	sep        = "\t",
	quote      = "",
	stringsAsFactors = FALSE
	);
DF.immunization[,'Country'] <- cleanup.country.names(input = DF.immunization[,'Country']);
str(DF.immunization);

####################################################################################################
DF.hiv <- read.table(
	file       = paste0(data.directory,'/hivaids_estimates_2012.csv'),
	header     = TRUE,
	na.strings = "…",
	sep        = "\t",
	quote      = "",
	stringsAsFactors = FALSE
	);

DF.hiv[,'adult.hiv.count.2011']      <- remove.space(input = DF.hiv[,'adult.hiv.count.2011']);
DF.hiv[,'Adult.hiv.count.low.2011']  <- remove.space(input = DF.hiv[,'Adult.hiv.count.low.2011']);
DF.hiv[,'Adult.hiv.count.high.2011'] <- remove.space(input = DF.hiv[,'Adult.hiv.count.high.2011']);
DF.hiv[,'women.hiv.15plus.2011']     <- remove.space(input = DF.hiv[,'women.hiv.15plus.2011']);
DF.hiv[,'children.hiv.2011']         <- remove.space(input = DF.hiv[,'children.hiv.2011']);

temp.colnames <- c(
	'adult.hiv.prevalence.percent.2011',
	'children.hiv.2011',
	'young.total.hiv.2011',
	'young.male.hiv.2011',
	'young.female.hiv.2011'
	);

for (temp.colname in temp.colnames) {
	DF.hiv[,temp.colname] <- reset.pt1(input = DF.hiv[,temp.colname]);
	}

DF.hiv[,c('country','adult.hiv.prevalence.percent.2011','children.hiv.2011')];

str(DF.hiv);

####################################################################################################
setdiff(DF.immunization[,'Country'],DF.hiv[,'country']);

setdiff(DF.hiv[,'country'],DF.immunization[,'Country']);

####################################################################################################
DF.combined <- merge(
	x    = DF.hiv,
	y    = DF.immunization,
	by.x = 'country',
	by.y = 'Country'
	);
str(DF.combined);
summary(DF.combined);

write.table(
	file      = 'hiv-immunization-combined.csv',
	x         = DF.combined,
	sep       = '\t',
	quote     = FALSE,
	row.names = FALSE
	);

####################################################################################################
selected.colnames <- c(
	'country','adult.hiv.prevalence.percent.2011',
	'BCG','DTP1','DTP3','HepB3','Hib3','Polio3','MCV1'
	);

DF.temp <- DF.combined[,selected.colnames];
str(DF.temp);
summary(DF.temp);

str(na.omit(DF.temp));

####################################################################################################
temp.filename <- 'adultHIV-BCG-2011.png';
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
temp.filename <- 'adultHIV-DTP3-2011.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = DTP3, y = adult.hiv.prevalence.percent.2011)
	);
my.ggplot <- my.ggplot + xlab("DTP3 (2011)");
my.ggplot <- my.ggplot + ylab("adult HIV prevalence (%), 2011");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 25), axis.text  = element_text(size = 25));
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,100));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
temp.filename <- 'adultHIV-HepB3-2011.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = HepB3, y = adult.hiv.prevalence.percent.2011)
	);
my.ggplot <- my.ggplot + xlab("HepB3 (2011)");
my.ggplot <- my.ggplot + ylab("adult HIV prevalence (%), 2011");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 25), axis.text  = element_text(size = 25));
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,100));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
temp.filename <- 'adultHIV-Hib3-2011.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = Hib3, y = adult.hiv.prevalence.percent.2011)
	);
my.ggplot <- my.ggplot + xlab("Hib3 (2011)");
my.ggplot <- my.ggplot + ylab("adult HIV prevalence (%), 2011");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 25), axis.text  = element_text(size = 25));
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,100));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
temp.filename <- 'adultHIV-polio3-2011.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = Polio3, y = adult.hiv.prevalence.percent.2011)
	);
my.ggplot <- my.ggplot + xlab("Polio3 (2011)");
my.ggplot <- my.ggplot + ylab("adult HIV prevalence (%), 2011");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 25), axis.text  = element_text(size = 25));
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,100));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
temp.filename <- 'adultHIV-MCV1-2011.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = MCV1, y = adult.hiv.prevalence.percent.2011)
	);
my.ggplot <- my.ggplot + xlab("MCV1 (2011)");
my.ggplot <- my.ggplot + ylab("adult HIV prevalence (%), 2011");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 25), axis.text  = element_text(size = 25));
my.ggplot <- my.ggplot + scale_x_continuous(limits=c(0,100));
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

