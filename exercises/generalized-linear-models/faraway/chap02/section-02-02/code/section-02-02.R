
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
data(orings);
orings;

####################################################################################################
setwd(output.directory);

step.size <- 0.001;
probabilities <- seq(step.size,1-step.size,step.size);

DF.logit <- data.frame(
	p    = probabilities,
	eta  = logit(probabilities),
	link = rep('logit',length(probabilities))
	);

DF.probit <- data.frame(
	p    = probabilities,
	eta  = qnorm(probabilities),
	link = rep('probit',length(probabilities))
	);

DF.loglog <- data.frame(
	p    = probabilities,
	eta  = log(-log(1-probabilities)),
	link = rep('log-log',length(probabilities))
	);

DF.link.functions <- rbind(DF.logit,DF.probit,DF.loglog);

temp.filename <- 'link-functions.png';
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_line(
	data    = DF.link.functions,
	mapping = aes(x = p, y = eta, colour = link)
	);
my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1),      breaks = seq(0,1,0.1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = 10*c(-1,1), breaks = seq(-10,10,2));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
results.logit <- glm(
	data    = orings,
	formula = cbind(damage,6 - damage) ~ temp,
	family  = binomial(link = logit)
	);
summary(results.logit);
pchisq(q = deviance(results.logit), df = df.residual(results.logit), lower = FALSE);

results.probit <- glm(
	data    = orings,
	formula = cbind(damage,6 - damage) ~ temp,
	family  = binomial(link = probit)
	);
summary(results.probit);
pchisq(q = deviance(results.probit), df = df.residual(results.probit), lower = FALSE);

results.cloglog <- glm(
	data    = orings,
	formula = cbind(damage,6 - damage) ~ temp,
	family  = binomial(link = cloglog)
	);
summary(results.cloglog);
pchisq(q = deviance(results.cloglog), df = df.residual(results.cloglog), lower = FALSE);

####################################################################################################
temperatures <- data.frame(temp = seq(0,100,1));

DF.predicted <- rbind(
	data.frame(
		temp = temperatures,
		fitted = predict(
			object  = results.logit,
			newdata = temperatures,
			type    = "response"
			),
		link = rep('logit',length(temperatures))
		),
	data.frame(
		temp = temperatures,
		fitted = predict(
			object  = results.probit,
			newdata = temperatures,
			type    = "response"
			),
		link = rep('probit',length(temperatures))
		),
	data.frame(
		temp = temperatures,
		fitted = predict(
			object  = results.cloglog,
			newdata = temperatures,
			type    = "response"
			),
		link = rep('cloglog',length(temperatures))
		)
	);

####################################################################################################
my.ggplot <- ggplot(data = NULL);

DF.temp <- aggregate(formula = damage ~ temp, data = orings, FUN = mean);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = temp, y = damage/6), data = DF.temp);
#my.ggplot <- my.ggplot + geom_point(mapping = aes(x = temp, y = damage/6), data = orings);

my.ggplot <- my.ggplot + geom_line(mapping = aes(x = temp, y = fitted, colour = link), data = DF.predicted);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,85), breaks = seq(0,80,10));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + xlab("temperature (Fahrenheit)");
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));

temp.filename <- 'figure-02-02.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

