
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
get.performance.metrics <- function(x = NULL) {
	output.list <- list(
		accuracy            = (x[1,1]+x[2,2]) / (x[1,1]+x[1,2]+x[2,1]+x[2,2]),
		sensitivity         = x[2,2] / (x[2,1]+x[2,2]),
		specificity         = x[1,1] / (x[1,1]+x[1,2]),
		false.negative.rate = x[2,1] / (x[1,1]+x[2,1]),
		false.positive.rate = x[1,2] / (x[1,2]+x[2,2])
		);
	return(output.list);
	}

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
setwd(output.directory);

resolution <- 100;

###################################################
data(Auto);
str(Auto);
summary(Auto);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (a) ###

DF.auto <- cbind(
	Auto,
	mpg01 = as.numeric(Auto[['mpg']] > median(Auto[['mpg']]))
	);
DF.auto[['year']] <- as.Date(paste0(1900+DF.auto[['year']],"-01-01"));
DF.auto[['year']] <- DF.auto[['year']] + sample(x=seq(-50,50,1),size=nrow(Auto),replace=TRUE);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
temp <- as.character(DF.auto[['name']]);
temp <- as.character(sapply(X=temp,FUN=function(x){return(strsplit(x," ")[[1]][1])}));

DF.auto[['manufacturer']] <- as.character(sapply(
	X   = as.character(DF.auto[['name']]),
	FUN = function(x){return(strsplit(x," ")[[1]][1])}
	));

DF.auto[['manufacturer']] <- gsub(
	x           = DF.auto[['manufacturer']],
	pattern     = "maxda",
	replacement = "mazda"
	);

DF.auto[['manufacturer']] <- gsub(
	x           = DF.auto[['manufacturer']],
	pattern     = "toyouta",
	replacement = "toyota"
	);

DF.auto[['manufacturer']] <- gsub(
	x           = DF.auto[['manufacturer']],
	pattern     = "vw",
	replacement = "volkswagen"
	);

DF.auto[['manufacturer']] <- gsub(
	x           = DF.auto[['manufacturer']],
	pattern     = "vokswagen",
	replacement = "volkswagen"
	);

DF.auto[['manufacturer']] <- as.factor(DF.auto[['manufacturer']]);
unique(DF.auto[['manufacturer']]);

#DF.auto[,c('name','manufacturer')];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b) ###

my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = year, y = jitter(mpg01,amount=0.25)),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);

#my.ggplot <- my.ggplot + scale_x_date(limits = c(as.Date("1969-01-01"),as.Date("1983-12-31")),date_breaks="1 year");
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(-0.5,1.5), breaks = c(0,1));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg01-vs-year.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = manufacturer, y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-manufacturer.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = year, y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-year.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = jitter(cylinders,amount=0.25), y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-cylinders.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = jitter(origin,amount=0.25), y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-origin.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = displacement, y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-displacement.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = horsepower, y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-horsepower.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = weight, y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-weight.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.auto,
	mapping = aes(x = acceleration, y = mpg),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);
my.ggplot <- my.ggplot + geom_hline(
	mapping = aes(yintercept=median(DF.auto[['mpg']])),
	colour  = "green"
	);

#my.ggplot <- my.ggplot + scale_x_continuous(limits = 20 * c(-1,1), breaks = seq(-20,20,2));
my.ggplot <- my.ggplot + scale_y_continuous(limits = c(0,60), breaks = seq(0,60,10));
my.ggplot <- my.ggplot + theme(
	title       = element_text(size = 20),
	axis.title  = element_text(size = 25),
	axis.text   = element_text(size = 12),
	axis.text.x = element_text(size = 15, angle = 90)
	);

temp.filename <- 'plot-mpg-vs-acceleration.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

###################################################

q();

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
	formula = direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
	data    = Weekly,
	family  = binomial(link = logit)
	);

summary(FIT.logistic);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (c) ###

temp <- as.data.frame(cbind(
	direction = FIT.logistic[['model']][,'direction'],
	fitted    = FIT.logistic[['fitted.values']],
	predicted = ceiling(FIT.logistic[['fitted.values']] - 0.5)
	));
str(temp);
summary(temp);

temp <- xtabs(data = temp, formula = ~ direction + predicted);
temp;
get.performance.metrics(x = temp);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (d) ###

is.training <- (Weekly[['Year']] <= 2008);

FIT.logistic <- glm(
	formula = direction ~ Lag2,
	data    = Weekly,
	family  = binomial(link = logit),
	subset  = is.training
	);

summary(FIT.logistic);

temp <- as.data.frame(cbind(
	direction = FIT.logistic[['model']][,'direction'],
	fitted    = FIT.logistic[['fitted.values']],
	predicted = ceiling(FIT.logistic[['fitted.values']] - 0.5)
	));
temp <- xtabs(data = temp, formula = ~ direction + predicted);
temp;
get.performance.metrics(x = temp);

temp <- Weekly[!is.training,];
temp <- as.data.frame(cbind(
	temp,
	fitted.values = predict(object=FIT.logistic, newdata=data.frame(Lag2=temp[,"Lag2"]), type="response")
	));
temp <- as.data.frame(cbind(
	temp,
	predicted = ceiling(temp[,'fitted.values'] - 0.5)
	));
temp <- xtabs(data = temp[,c('direction','predicted')], formula = ~ direction + predicted);
temp;
get.performance.metrics(x = temp);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (e) ###

FIT.lda <- lda(
	formula = direction ~ Lag2,
	data    = Weekly,
	subset  = is.training
	);

temp <- Weekly[!is.training,];
temp <- as.data.frame(cbind(
	temp,
	predicted = predict(object=FIT.lda, newdata=data.frame(Lag2=temp[,"Lag2"]), type="response")[['class']]
	));
str(temp);
temp <- xtabs(data = temp[,c('direction','predicted')], formula = ~ direction + predicted);
temp;
get.performance.metrics(x = temp);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (f) ###

FIT.qda <- qda(
	formula = direction ~ Lag2,
	data    = Weekly,
	subset  = is.training
	);

temp <- Weekly[!is.training,];
temp <- as.data.frame(cbind(
	temp,
	predicted = predict(object=FIT.qda, newdata=data.frame(Lag2=temp[,"Lag2"]), type="response")[['class']]
	));
str(temp);
temp <- xtabs(data = temp[,c('direction','predicted')], formula = ~ direction + predicted);
temp;
get.performance.metrics(x = temp);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (g) ###

FIT.knn <- knn(
	train = data.frame(Lag2 = Weekly[ is.training,"Lag2"]),
	test  = data.frame(Lag2 = Weekly[!is.training,"Lag2"]),
	cl    = Weekly[ is.training,"direction"],
	k     = 1
	);

temp <- Weekly[!is.training,];
temp <- as.data.frame(cbind(temp, predicted = FIT.knn));
str(temp);
temp <- xtabs(data = temp[,c('direction','predicted')], formula = ~ direction + predicted);
temp;
get.performance.metrics(x = temp);

###################################################

q();

