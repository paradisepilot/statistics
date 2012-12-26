
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];
code.directory    <- command.arguments[2];

####################################################################################################
require(LearnBayes);
require(ggplot2);
require(scales);
require(coda);
#require(sn);

source(paste(code.directory, "utils-monte-carlo.R", sep = "/"));

setwd(output.directory);

####################################################################################################
str(hearttransplants);
summary(hearttransplants);
hearttransplants;

### Fig. 7.2, p.156 ################################################################################
png("Fig7-02.png");
my.ggplot <- ggplot(data = NULL);
DF.temp <- data.frame(
	log.e    = log(hearttransplants[,'e']),
	y.over.e = hearttransplants[,'y'] / hearttransplants[,'e'],
	y        = as.character(hearttransplants[,'y'])
	);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = log.e, y = y.over.e)
	);
my.ggplot <- my.ggplot + geom_text(
	data    = DF.temp,
	mapping = aes(x = log.e, y = y.over.e, label = y),
	#hjust   = -0.5
	vjust   = 2
	);
my.ggplot <- my.ggplot + xlim(6,10) + ylim(0,0.004);
my.ggplot;
dev.off();

### Fig. 7.3, p.159 ################################################################################
alpha <- sum(hearttransplants[,'y']);
beta  <- sum(hearttransplants[,'e']);
alpha;
beta;

sample.size <- 1e+5;
lambda.sample <- rgamma(n = sample.size, shape = alpha, rate = beta);
y.predicted <- rpois(n = length(lambda.sample), lambda = hearttransplants[94,'e'] * lambda.sample);

png("Fig7-03.png");
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_histogram(
	data     = data.frame(y.predicted = y.predicted),
	mapping  = aes(x = y.predicted),
	binwidth = 1,
	colour   = alpha("black",0.5),
	fill     = alpha("#CC5500",0.5),
	);
my.ggplot <- my.ggplot + geom_vline(xintercept = hearttransplants[94,'y']);
my.ggplot;
dev.off

temp <- mean(y.predicted > hearttransplants[94,'y']);
min(temp,1-temp);

####################################################################################################

q();

