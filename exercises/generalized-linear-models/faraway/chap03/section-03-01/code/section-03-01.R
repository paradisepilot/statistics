
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

setwd(output.directory);

####################################################################################################
data(gala);
gala <- gala[,-2];

str(gala);
gala;

####################################################################################################
temp.filename <- 'figure-03-01a.png';

results.lm <- lm(formula = Species ~ ., data = gala);

my.ggplot <- ggplot(data = NULL);

DF.temp <- data.frame(
	fitted   = predict(object = results.lm, type = 'response'),
	residual = residuals(results.lm)
	);

my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = fitted, y = residual)
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-40,400),  breaks = seq(-50,400,50));
my.ggplot <- my.ggplot + scale_y_continuous(limits = 200*c(-1,1), breaks = 200 * seq(-1,1,0.25));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
temp.filename <- 'figure-03-01b.png';

results.lm <- lm(formula = sqrt(Species) ~ ., data = gala);
summary(results.lm);

my.ggplot <- ggplot(data = NULL);

DF.temp <- data.frame(
	fitted   = predict(object = results.lm, type = 'response'),
	residual = residuals(results.lm)
	);

my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = fitted, y = residual)
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = 20*c( 0,1), breaks = 20 * seq( 0,1,0.1));
my.ggplot <- my.ggplot + scale_y_continuous(limits =  6*c(-1,1), breaks =  6 * seq(-1,1,0.5));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 12, units = 'in');

####################################################################################################
results.poisson <- glm(
	formula = Species ~ .,
	data    = gala,
	family  = poisson
	);
summary(results.poisson);

temp.filename <- 'figure-03-02a.png';
png(temp.filename);
halfnorm(residuals(results.poisson));
dev.off();

temp.filename <- 'figure-03-02b.png';

my.ggplot <- ggplot(data = NULL);

DF.temp <- data.frame(
	x = fitted.values(results.poisson),
	y = (residuals(results.poisson, type = 'response'))^2
	);

my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = log(x), y = log(y))
	);

my.ggplot <- my.ggplot + geom_abline(intercept = 0, slope = 1);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-1,10), breaks = seq(-1,10,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-1,10), breaks = seq(-1,10,1));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 6, units = 'in');

temp.filename <- 'fitted-vs-observed.png';

my.ggplot <- ggplot(data = NULL);

DF.temp <- data.frame(
	observed = gala[,'Species'],
	fitted   = fitted.values(results.poisson)
	);

my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = observed, y = fitted)
	);

my.ggplot <- my.ggplot + geom_abline(intercept = 0, slope = 1);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(0,500), breaks = seq(0,500,100));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,500), breaks = seq(0,500,100));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 30),
	axis.text  = element_text(size = 25)
	);

ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 6, width = 6, units = 'in');

####################################################################################################

(X <- model.matrix(results.poisson));
n.observations <- nrow(X);
n.parameters   <- ncol(X); 

dispersion <- sum((residuals(results.poisson,type='pearson'))^2) / (n.observations - n.parameters);
dispersion;

summary(results.poisson, dispersion = dispersion);

drop1(results.poisson, test = 'F');

####################################################################################################

q();

