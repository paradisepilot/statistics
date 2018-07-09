
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory    <- command.arguments[1];
code.directory    <- command.arguments[2];
output.directory  <- command.arguments[3];
tmp.directory     <- command.arguments[4];

setwd(output.directory);

###################################################
library(ISLR);
library(MASS);
library(class);
library(ggplot2);
library(boot);

#source(paste(code.directory, "ex-04-07-11-b.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-d.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-e.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-f.R", sep = "/"));
#source(paste(code.directory, "ex-04-07-11-g.R", sep = "/"));
#source(paste(code.directory, "getDFauto.R",     sep = "/"));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

resolution <- 100;

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (a) ###
set.seed(1);

temp.x <- rnorm(100);
DF.simulated <- data.frame(
	x  = temp.x,
	x2 = temp.x ^ 2,
	x3 = temp.x ^ 3,
	x4 = temp.x ^ 4,
	y  = temp.x - 2*temp.x^2 + rnorm(100)
	);
#DF.simulated;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (b) ###

my.ggplot <- ggplot(data = NULL) + theme_bw();
my.ggplot <- my.ggplot + geom_point(
	data    = DF.simulated,
	mapping = aes(x = x, y = y),
	alpha   = 0.5,
	size    = 0.8,
	colour  = "red"
	);

my.ggplot <- my.ggplot + scale_x_continuous(limits = c(-3.5,3.5), breaks = seq(-4,4));
my.ggplot <- my.ggplot + theme(
	title      = element_text(size = 20),
	axis.title = element_text(size = 25),
	axis.text  = element_text(size = 12)
	);

temp.filename <- 'plot-05-04-07.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 8, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (c) ###
set.seed(1234567);

loocv <- function(
	DF.input        = NULL,
	leave.out.index = NULL
	) {
	return(sapply(
		X = c(
			"y ~ x",
			"y ~ x + x2",
			"y ~ x + x2 + x3",
			"y ~ x + x2 + x3 + x4"
			),
		FUN = function(input.formula = NULL) {
			as.numeric(predict(
				object  = lm(formula = input.formula, data = DF.input[-leave.out.index,]),
				newdata = DF.input[leave.out.index,],
				type    = "response"
				))
			}
		));
	}

loocv(DF.input = DF.simulated, leave.out.index = 1);

DF.simulated <- cbind(
	DF.simulated,
	t(sapply(
		X   = 1:nrow(DF.simulated),
		FUN = function(i){ return( loocv(DF.input = DF.simulated, leave.out.index = i) ); }
		))
	);
str(DF.simulated);

mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x'])^2);
mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x + x2'])^2);
mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x + x2 + x3'])^2);
mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x + x2 + x3 + x4'])^2);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (d) ###
set.seed(7654321);

DF.simulated <- cbind(
	DF.simulated,
	t(sapply(
		X   = 1:nrow(DF.simulated),
		FUN = function(i){ return( loocv(DF.input = DF.simulated, leave.out.index = i) ); }
		))
	);

mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x'])^2);
mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x + x2'])^2);
mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x + x2 + x3'])^2);
mean((DF.simulated[,'y'] - DF.simulated[,'y ~ x + x2 + x3 + x4'])^2);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
### (f) ###

summary(lm(formula = y ~ x + x2 + x3 + x4, data = DF.simulated));

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

q();

