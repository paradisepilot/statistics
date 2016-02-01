
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

###################################################
library(ISLR);
library(MASS);
library(class);
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
setwd(output.directory);

resolution <- 100;

###################################################
data(Weekly);
str(Weekly);
summary(Weekly);

Weekly[,'direction'] <- (1 + sign(Weekly[,'Today']))/2;

Weekly[1:10,c("Year","Today","Direction","direction")];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (a) ###

my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = Weekly,
	mapping = aes(x = Today, y = Lag1),
	alpha   = 0.3,
	size    = 0.3,
	colour  = "red"
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 25),
	axis.text  = element_text(size = 12)
	);

temp.filename <- 'scatterplot-lag1-vs-today.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 8, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = Weekly,
	mapping = aes(x = Today, y = Lag2),
	alpha   = 0.3,
	size    = 0.3,
	colour  = "red"
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 25),
	axis.text  = element_text(size = 12)
	);

temp.filename <- 'scatterplot-lag2-vs-today.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 8, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = Weekly,
	mapping = aes(x = jitter(Year,amount=0.12), y = Volume),
	alpha   = 0.3,
	size    = 0.5,
	colour  = "red"
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(1989,2011), breaks = seq(1989,2011,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = 10 * c(0,1), breaks = seq(0,10,1));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 10, angle = 90)
	);

temp.filename <- 'scatterplot-volume-vs-year.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = Weekly,
	mapping = aes(x = jitter(Year,amount=0.12), y = Today),
	alpha   = 0.5,
	size    = 0.3,
	colour  = "red"
	);

my.ggplot <- my.ggplot + geom_hline(mapping = aes(yintercept=0), colour = "gray");
my.ggplot <- my.ggplot + scale_x_continuous(limits = c(1989,2011), breaks = seq(1989,2011,1));
my.ggplot <- my.ggplot + scale_y_continuous(limits = 19 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 10, angle = 90)
	);

temp.filename <- 'scatterplot-today-vs-year.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b) ###

FIT.logistic <- glm(
	data    = Weekly,
	formula = direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
	family  = binomial(link = logit)
	);

summary(FIT.logistic);
str(FIT.logistic);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (c) ###

temp <- as.data.frame(cbind(
	direction = FIT.logistic[['model']][,'direction'],
	fitted    = FIT.logistic[['fitted.values']],
	predicted = ceiling(FIT.logistic[['fitted.values']] - 0.5)
	));
str(temp);
summary(temp);
temp[1:20,];

sum(temp[,'direction']);
table(temp[,'direction'],temp[,'predicted']);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (d) ###

FIT.logistic <- glm(
	data    = Weekly[Weekly[['Year']] <= 2007,],
	formula = direction ~ Lag2,
	family  = binomial(link = logit)
	);

summary(FIT.logistic);

temp <- as.data.frame(cbind(
	direction = FIT.logistic[['model']][,'direction'],
	fitted    = FIT.logistic[['fitted.values']],
	predicted = ceiling(FIT.logistic[['fitted.values']] - 0.5)
	));
str(temp);
summary(temp);
temp[1:20,];

sum(temp[,'direction']);
table(temp[,'direction'],temp[,'predicted']);

###################################################

q();

