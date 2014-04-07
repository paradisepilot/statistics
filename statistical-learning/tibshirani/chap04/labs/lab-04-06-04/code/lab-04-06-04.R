
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(ISLR);
library(MASS);
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

####################################################################################################
lda.fit <- lda(formula = Direction ~ Lag1 + Lag2, data = Smarket);

results.predict.lda <- predict(object = lda.fit, type = "response");
DF.lda.predictions <- data.frame(prediction = results.predict.lda[['class']],results.predict.lda[['posterior']],results.predict.lda[['x']]);

DF.Smarket <- cbind(Smarket, prediction = DF.lda.predictions[,'prediction']);

table(DF.Smarket[,'prediction'], DF.Smarket[,'Direction']);
(training.accuracy <- mean(DF.Smarket[,'prediction']==DF.Smarket[,'Direction']));

####################################################################################################
N <- 5000;
DF.output <- data.frame(n = 1:N, accuracy = numeric(length = N));

for (i in 1:nrow(DF.output)) {
	is.training <- sample(x = c(TRUE,FALSE), size = nrow(Smarket), replace = TRUE, prob = c(0.6,0.4));
	Smarket.testing  <- Smarket[!is.training,];

	lda.fit <- lda(formula = Direction ~ Lag1 + Lag2, data = Smarket[is.training,]);
	results.predict.lda <- predict(object = lda.fit, type = "response");

	DF.output[i,'accuracy'] <- mean(results.predict.lda[['class']] == Smarket.testing[,'Direction']);
	}

summary(DF.output);

my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = accuracy, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = accuracy), data = DF.output);
my.ggplot <- my.ggplot + geom_vline(xintercept = training.accuracy, colour = 'red');

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'accuracy-histogram-LDA-Lag1-Lag2.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
qda.fit <- qda(formula = Direction ~ Lag1 + Lag2, data = Smarket);

results.predict.qda <- predict(object = qda.fit, type = "response");
DF.qda.predictions <- data.frame(prediction = results.predict.qda[['class']],results.predict.qda[['posterior']]);

DF.Smarket <- cbind(Smarket, prediction = DF.qda.predictions[,'prediction']);

table(DF.Smarket[,'prediction'], DF.Smarket[,'Direction']);
(training.accuracy <- mean(DF.Smarket[,'prediction']==DF.Smarket[,'Direction']));

N <- 5000;
DF.output <- data.frame(n = 1:N, accuracy = numeric(length = N));

for (i in 1:nrow(DF.output)) {
	is.training <- sample(x = c(TRUE,FALSE), size = nrow(Smarket), replace = TRUE, prob = c(0.6,0.4));
	Smarket.testing  <- Smarket[!is.training,];

	qda.fit <- qda(formula = Direction ~ Lag1 + Lag2, data = Smarket[is.training,]);
	results.predict.qda <- predict(object = qda.fit, type = "response");

	DF.output[i,'accuracy'] <- mean(results.predict.qda[['class']] == Smarket.testing[,'Direction']);
	}

summary(DF.output);

my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = accuracy, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = accuracy), data = DF.output);
my.ggplot <- my.ggplot + geom_vline(xintercept = training.accuracy, colour = 'red');

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'accuracy-histogram-QDA-Lag1-Lag2.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

