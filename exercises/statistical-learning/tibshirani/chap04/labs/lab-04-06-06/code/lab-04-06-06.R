
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
data(Caravan);
str(Caravan);
summary(Caravan);

Caravan <- Caravan[sample(x = 1:nrow(Caravan), size = nrow(Caravan), replace = FALSE),];

(yes.proportion <- nrow(Caravan['Yes' == Caravan,]) / nrow(Caravan));

####################################################################################################
setwd(output.directory);

####################################################################################################
N <- 1000;

colnames.covariates  <- setdiff(colnames(Caravan),'Purchase');
Caravan.standardized <- scale(Caravan[,colnames.covariates]);
Caravan.standardized <- data.frame(Caravan.standardized,Purchase = Caravan[,'Purchase']);

print('str(Caravan.standardized)');
print( str(Caravan.standardized) );

DF.output <- data.frame(n = 1:N, sensitivity = numeric(length = N), precision = numeric(length = N));
for (i in 1:nrow(DF.output)) {
	print(paste0('i = ',i));
	is.training <- sample(x = c(TRUE,FALSE), size = nrow(Caravan.standardized), replace = TRUE, prob = c(0.6,0.4));
	glm.fit <- glm(
		formula = Purchase ~ .,
		data    = Caravan.standardized[is.training,],
		family  = binomial
		);
	glm.predicted.probs <- predict.glm(object = glm.fit, newdata = Caravan.standardized[!is.training,colnames.covariates]);
	glm.predictions <- factor(rep('No',length(glm.predicted.probs)),levels = levels(Caravan[,'Purchase']));
	glm.predictions[glm.predicted.probs > 0.25] <- 'Yes';
	temp.table <- table(Caravan.standardized[!is.training,'Purchase'],glm.predictions);
	DF.output[i,'sensitivity'] <- temp.table[2,2] / sum(temp.table[2,]);
	DF.output[i,'precision']   <- temp.table[2,2] / sum(temp.table[,2]);
	}

summary(DF.output);

####################################################################################################
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = sensitivity, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = sensitivity), data = DF.output);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'histogram-sensitivity-logistic.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = precision, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = precision), data = DF.output);
my.ggplot <- my.ggplot + geom_vline(xintercept = yes.proportion, colour = 'red');

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'histogram-precision-logistic.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = precision, y = sensitivity), data = DF.output);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'scatterplot-precision-sensitivity-logistic.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
####################################################################################################
N <- 1000;

colnames.covariates  <- setdiff(colnames(Caravan),'Purchase');
Caravan.standardized <- scale(Caravan[,colnames.covariates]);
Caravan.standardized <- cbind(Caravan.standardized,Purchase = Caravan[,'Purchase']);

DF.output <- data.frame(n = 1:N, sensitivity = numeric(length = N), precision = numeric(length = N));
for (i in 1:nrow(DF.output)) {
	print(paste0('i = ',i));
	is.training <- sample(x = c(TRUE,FALSE), size = nrow(Caravan.standardized), replace = TRUE, prob = c(0.6,0.4));
	knn.predictions  <- knn(
		k     = 5,
		train = Caravan.standardized[ is.training,colnames.covariates],
		cl    = Caravan.standardized[ is.training,'Purchase'],
		test  = Caravan.standardized[!is.training,colnames.covariates]
		);
	temp.table <- table(Caravan.standardized[!is.training,'Purchase'],knn.predictions);
	DF.output[i,'sensitivity'] <- temp.table[2,2] / sum(temp.table[2,]);
	DF.output[i,'precision']   <- temp.table[2,2] / sum(temp.table[,2]);
	}

summary(DF.output);

####################################################################################################
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = sensitivity, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = sensitivity), data = DF.output);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'histogram-sensitivity-knn.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_histogram(mapping = aes(x = precision, y = ..density..), data = DF.output, binwidth = 0.01, alpha = 0.6);
my.ggplot <- my.ggplot + geom_density(mapping = aes(x = precision), data = DF.output);
my.ggplot <- my.ggplot + geom_vline(xintercept = yes.proportion, colour = 'red');

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
#my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1),  breaks = seq(0,1,0.2));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'histogram-precision-knn.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(mapping = aes(x = precision, y = sensitivity), data = DF.output);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,1), breaks = seq(0,1,0.1));
my.ggplot <- my.ggplot + theme(title = element_text(size = 20), axis.title = element_text(size = 30), axis.text  = element_text(size = 25));
temp.filename <- 'scatterplot-precision-sensitivity-knn.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################

q();

