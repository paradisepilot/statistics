
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

####################################################################################################
library(ISLR);
library(MASS);
library(class);
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
N <- 5000;
DF.output <- data.frame(n = 1:N, accuracy = numeric(length = N));
for (i in 1:nrow(DF.output)) {
	is.training <- sample(x = c(TRUE,FALSE), size = nrow(Smarket), replace = TRUE, prob = c(0.6,0.4));
	knn.predictions  <- knn(
		k     = 20,
		train = Smarket[ is.training,c('Lag1','Lag2')],
		cl    = Smarket[ is.training,'Direction'],
		test  = Smarket[!is.training,c('Lag1','Lag2')]
		);
	DF.output[i,'accuracy'] <- mean(knn.predictions == Smarket[!is.training,'Direction']);
	}

summary(DF.output);

my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = accuracy, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = accuracy), data = DF.output);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'accuracy-histogram-knn.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

