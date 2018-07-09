
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(faraway);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 100;

####################################################################################################
data(bliss);
bliss[,'dead']  <- as.integer(bliss[,'dead']);
bliss[,'alive'] <- as.integer(bliss[,'alive']);
bliss[,'conc']  <- as.numeric(bliss[,'conc']);
str(bliss);
bliss;

####################################################################################################
setwd(output.directory);

results.logit   <- glm(data=bliss,formula=cbind(dead,alive)~conc,family=binomial(link=  logit));
results.probit  <- glm(data=bliss,formula=cbind(dead,alive)~conc,family=binomial(link= probit));
results.cloglog <- glm(data=bliss,formula=cbind(dead,alive)~conc,family=binomial(link=cloglog));

summary(results.logit);
summary(results.probit);
summary(results.cloglog);

####################################################################################################
DF.concentrations <- data.frame(conc = seq(-2,8,0.1));

DF.predicted <- rbind(
	data.frame(
		conc      = DF.concentrations[,'conc'],
		predicted = predict(object = results.logit, newdata = DF.concentrations, type = 'response'),
		link      = rep('logit',nrow(DF.concentrations))
		),
	data.frame(
		conc      = DF.concentrations[,'conc'],
		predicted = predict(object = results.probit, newdata = DF.concentrations, type = 'response'),
		link      = rep('probit',nrow(DF.concentrations))
		),
	data.frame(
		conc      = DF.concentrations[,'conc'],
		predicted = predict(object = results.cloglog, newdata = DF.concentrations, type = 'response'),
		link      = rep('cloglog',nrow(DF.concentrations))
		)
	);

####################################################################################################
temp.filename <- 'figure-02-03a.png';
my.ggplot <- ggplot(data = NULL);

DF.temp <- cbind(bliss, total = bliss[,'dead'] + bliss[,'alive']);
DF.temp[,'observed'] <- DF.temp[,'dead'] / DF.temp[,'total'];
DF.temp;

my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = conc, y = observed)
	);

my.ggplot <- my.ggplot + geom_line(
	data    = DF.predicted,
	mapping = aes(x = conc, y = predicted, colour = link)
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-2,8), breaks = seq(-2,8,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + xlab("concentration");
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
temp.filename <- 'figure-02-03b.png';
my.ggplot <- ggplot(data = NULL);

DF.predicted <- cbind(
	DF.predicted[  'logit'==DF.predicted[,'link'],c('conc','predicted')],
	probit  = DF.predicted[ 'probit'==DF.predicted[,'link'],'predicted'],
	cloglog = DF.predicted['cloglog'==DF.predicted[,'link'],'predicted']
	);
colnames(DF.predicted) <- gsub(x = colnames(DF.predicted), pattern = 'predicted', replacement = 'logit');
DF.predicted;

DF.temp <- rbind(
	data.frame(
		conc  = DF.predicted[,'conc'],
		ratio = DF.predicted[,'probit'] / DF.predicted[,'logit'],
		tail  = rep('lower',nrow(DF.predicted))
		),
	data.frame(
		conc  = DF.predicted[,'conc'],
		ratio = (1-DF.predicted[,'probit']) / (1-DF.predicted[,'logit']),
		tail  = rep('upper',nrow(DF.predicted))
		)
	);

my.ggplot <- my.ggplot + geom_line(
	data    = DF.temp,
	mapping = aes(x = conc, y = ratio, colour = tail)
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-2,8), breaks = seq(-2,8,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1.2),  breaks = seq(0,1.2,0.2));
my.ggplot <- my.ggplot + xlab("concentration");
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(
	file   = temp.filename,
	plot   = my.ggplot,
	dpi    = resolution,
	height = 6,
	width  = 12,
	units  = 'in'
	);

####################################################################################################
temp.filename <- 'figure-02-03c.png';
my.ggplot <- ggplot(data = NULL);

DF.temp <- rbind(
	data.frame(
		conc  = DF.predicted[,'conc'],
		ratio = DF.predicted[,'cloglog'] / DF.predicted[,'logit'],
		tail  = rep('lower',nrow(DF.predicted))
		),
	data.frame(
		conc  = DF.predicted[,'conc'],
		ratio = (1-DF.predicted[,'cloglog']) / (1-DF.predicted[,'logit']),
		tail  = rep('upper',nrow(DF.predicted))
		)
	);

my.ggplot <- my.ggplot + geom_line(
	data    = DF.temp,
	mapping = aes(x = conc, y = ratio, colour = tail)
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-2,8), breaks = seq(-2,8,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,3.2),  breaks = seq(0,3.2,0.5));
my.ggplot <- my.ggplot + xlab("concentration");
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(
	file   = temp.filename,
	plot   = my.ggplot,
	dpi    = resolution,
	height = 6,
	width  = 12,
	units  = 'in'
	);

####################################################################################################

q();

