
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(ggplot2);

#source(paste(code.directory, "bugs-chains.R", sep = "/"));
#source(paste(code.directory, "which-bugs.R",  sep = "/"));

####################################################################################################
setwd(output.directory);

####################################################################################################
DF.ungrouped.data <- read.delim(
	file = paste0(data.directory,'/table-07-08-WAIS-senility.csv'),
	sep  = '\t'
	);
str(DF.ungrouped.data);

temp <- table(DF.ungrouped.data);
DF.grouped.data <- data.frame(
	WAIS     = as.integer(rownames(temp)),
	senile.1 = temp[,2],
	senile.0 = temp[,1],
	n        = temp[,1] + temp[,2],
	p        = temp[,2] / (temp[,1] + temp[,2])
	);
str(DF.grouped.data);
DF.grouped.data;

####################################################################################################
glm.grouped <- glm(
	formula = cbind(senile.1,senile.0) ~ WAIS,
	data    = DF.grouped.data,
	family  = binomial(link = "logit")
	);
summary(glm.grouped);

glm.ungrouped <- glm(
	formula = senility ~ WAIS,
	data    = DF.ungrouped.data,
	family  = binomial(link = "logit")
	);
summary(glm.ungrouped);

####################################################################################################
resolution <- 100;
graphics.format <- 'png';

my.filename <- paste('example-07-08-ungrouped',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + ylim(-0.10,1.10);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.ungrouped.data,
	mapping = aes(x = WAIS, y = jitter(senility, factor = 0.15)),
	alpha   = 0.25
	);

betas.hat <- coefficients(glm.ungrouped);
betas.hat;

temp.x <- seq(3.9,20.1,0.1);
temp.y <- betas.hat[1] + betas.hat[2] * temp.x;
temp.y <- exp(temp.y) / (1 + exp(temp.y));
my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
	col     = 'orange'
	);

ggsave(
	file   = my.filename,
	plot   = my.ggplot,
	height = 0.5 * par("din")[1],
	dpi    = resolution,
	units  = 'in'
	);

####################################################################################################
my.filename <- paste('example-07-08-grouped',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + ylim(-0.05,1.05);
my.ggplot <- my.ggplot + geom_point(data = DF.grouped.data, mapping = aes(x = WAIS, y = p));

betas.hat <- coefficients(glm.grouped);
betas.hat;

temp.x <- seq(3.9,20.1,0.1);
temp.y <- betas.hat[1] + betas.hat[2] * temp.x;
temp.y <- exp(temp.y) / (1 + exp(temp.y));
my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
	col     = 'orange'
	);

ggsave(
	file   = my.filename,
	plot   = my.ggplot,
	height = 0.5 * par("din")[1],
	dpi    = resolution,
	units  = 'in'
	);

####################################################################################################

q();

