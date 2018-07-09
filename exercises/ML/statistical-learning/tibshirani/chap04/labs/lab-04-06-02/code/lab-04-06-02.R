
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(ISLR);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

resolution <- 100;

####################################################################################################
data(Smarket);
str(Smarket);
summary(Smarket);

Smarket[,'day'] <- 1:nrow(Smarket);

####################################################################################################
setwd(output.directory);

my.ggplot <- ggplot(data = NULL);

my.ggplot <- my.ggplot + geom_line(mapping = aes(x = day, y = Volume), data = Smarket);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,85), breaks = seq(0,80,10));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
#my.ggplot <- my.ggplot + xlab("temperature (Fahrenheit)");
#my.ggplot <- my.ggplot + ggtitle(paste0("log.rank: ",formatC(logrank.stat),", pval: ",logrank.pval));

my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'SP500-daily-volumes.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
glm.fit <- glm(
	formula = Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
	data    = Smarket,
	family  = binomial()
	);
summary(glm.fit);

glm.probs <- predict(object = glm.fit, type = "response");
glm.predictions <- factor(rep('Down',nrow(Smarket)), levels = levels(Smarket[,'Direction']));
glm.predictions[glm.probs > 0.5] <- 'Up';
DF.Smarket <- cbind(Smarket,predict = glm.predictions);
str(DF.Smarket);

table(DF.Smarket[,'predict'], DF.Smarket[,'Direction']);
(training.accuracy <- mean(DF.Smarket[,'predict']==DF.Smarket[,'Direction']));

####################################################################################################
N <- 1000;
DF.output <- data.frame(n = 1:N, accuracy = numeric(length = N));

for (i in 1:nrow(DF.output)) {

	is.training <- sample(x = c(TRUE,FALSE), size = nrow(Smarket), replace = TRUE, prob = c(0.6,0.4));
	Smarket.testing  <- Smarket[!is.training,];

	glm.fit <- glm(
		formula = Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
		data    = Smarket[is.training,],
		family  = binomial()
		);

	glm.probs <- predict(object = glm.fit, newdata = Smarket.testing, type = "response");
	glm.predictions <- factor(rep('Down',nrow(Smarket.testing)), levels = levels(Smarket[,'Direction']));
	glm.predictions[glm.probs > 0.5] <- 'Up';

	DF.output[i,'accuracy'] <- mean(glm.predictions==Smarket.testing[,'Direction']);
	}

summary(DF.output);

my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = accuracy, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = accuracy), data = DF.output);
my.ggplot <- my.ggplot + geom_vline(xintercept = training.accuracy, colour = 'red');

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'accuracy-histogram.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
N <- 1000;
DF.output <- data.frame(n = 1:N, accuracy = numeric(length = N));

for (i in 1:nrow(DF.output)) {

	is.training <- sample(x = c(TRUE,FALSE), size = nrow(Smarket), replace = TRUE, prob = c(0.6,0.4));
	Smarket.testing  <- Smarket[!is.training,];

	glm.fit <- glm(
		formula = Direction ~ Lag1 + Lag2,
		data    = Smarket[is.training,],
		family  = binomial()
		);

	glm.probs <- predict(object = glm.fit, newdata = Smarket.testing, type = "response");
	glm.predictions <- factor(rep('Down',nrow(Smarket.testing)), levels = levels(Smarket[,'Direction']));
	glm.predictions[glm.probs > 0.5] <- 'Up';

	DF.output[i,'accuracy'] <- mean(glm.predictions==Smarket.testing[,'Direction']);
	}

summary(DF.output);

my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = accuracy, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = accuracy), data = DF.output);
my.ggplot <- my.ggplot + geom_vline(xintercept = training.accuracy, colour = 'red');

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'accuracy-histogram-Lag1-Lag2.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

