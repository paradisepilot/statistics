
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory  <- command.arguments[1];

####################################################################################################
setwd(output.directory);
library(LearnBayes);
library(ggplot2);
library(scales);

### SECTION 4.4 ####################################################################################
bioassay <- data.frame(
	log.dose    = c(-0.86, -0.30, -0.05, 0.73),
	sample.size = c(5,5,5,5),
	deaths      = c(0,1,3,5)
	);
bioassay;

glm.results <- glm(
	cbind(deaths,I(sample.size-deaths)) ~ log.dose,
	data = bioassay,
	family = "binomial"
	);
summary(glm.results);

prior.pseudodata <- data.frame(
	log.dose    = c(-0.70, 0.60),
	sample.size = c( 4.68, 2.84),
	deaths      = c( 1.12, 2.10)
	);
prior.pseudodata;

posterior.pseudodata <- rbind(bioassay,prior.pseudodata);
colnames(posterior.pseudodata) <- c('x','n','y');
posterior.pseudodata;

grid.size  <- 1e-2;
grid.beta0 <- -3 + (3-(-3)) * seq(0,1,grid.size);
grid.beta1 <- -1 + (9-(-1)) * seq(0,1,grid.size);

png("Fig4-5_contour-bioassay.png");
DF.temp <- expand.grid(x = grid.beta0, y = grid.beta1);
DF.temp <- cbind(
	DF.temp,
	log.density = apply(
		X = DF.temp,
		MARGIN = 1,
		FUN =function(b) {return(logisticpost(beta=b,data=posterior.pseudodata));} 
		)
	);
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + stat_contour(data = DF.temp, aes(x,y,z=log.density));
my.ggplot;
dev.off();

png("Fig4-6_contour-points-bioassay.png");
DF.points <- as.data.frame(simcontour(
	logf = logisticpost,
	limits = c(-3,3,-1,9),
	data = posterior.pseudodata,
	m = 5000
	));
my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + stat_contour(data = DF.temp, aes(x,y,z=log.density));
my.ggplot <- my.ggplot + geom_point(data = DF.points, aes(x,y), colour = alpha("darkolivegreen", 0.25));
my.ggplot;
dev.off();

png("Fig4-7_histogram-beta1.png");
qplot(x = DF.points[,'y'], geom = "density");
dev.off();

png("Fig4-8_histogram-LD50.png");
theta <- - DF.points[,'x'] / DF.points[,'y']
qplot(x = theta, geom = "histogram", binwidth = 0.05);
dev.off();

quantile(theta,c(0.025,0.975));

