
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
DF.data <- read.delim(
	file = paste0(data.directory,'/table-07-05-embryonic-anthers.csv'),
	sep  = '\t'
	);
DF.data[,'storage'] <- as.factor(DF.data[,'storage']);
DF.data[,'num.otherwise.anthers'] <- DF.data[,'num.prepared.anthers'] - DF.data[,'num.embryonic.anthers'];
str(DF.data);
DF.data;

####################################################################################################
model1.glm <- glm(
	formula = cbind(num.embryonic.anthers,num.otherwise.anthers) ~ storage * log(centrifuge),
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(model1.glm);

model2.glm <- glm(
	formula = cbind(num.embryonic.anthers,num.otherwise.anthers) ~ storage + log(centrifuge),
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(model2.glm);

model3.glm <- glm(
	formula = cbind(num.embryonic.anthers,num.otherwise.anthers) ~ 1 + log(centrifuge),
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(model3.glm);

####################################################################################################
# comparing:
# (*) fitting two parallel lines with distinct intercepts, one for each storage condition
# (*) fitting two lines with distinct intercepts and distinct slopes, one for each storage condition
anova(model2.glm,model1.glm);

# comparing (effect on storage on response, after adjusting for centrifuge):
# (*) fitting one line through all data points
# (*) fitting two parallel lines with distinct intercepts, one for each storage condition
anova(model3.glm,model2.glm);

####################################################################################################
resolution <- 100;
graphics.format <- 'png';
my.filename <- paste('example-07-04-01',graphics.format,sep='.');
my.ggplot <- ggplot();
#my.ggplot <- my.ggplot + xlim(-200,6200);
my.ggplot <- my.ggplot + ylim(0.48,0.75);
my.ggplot <- my.ggplot + geom_point(
        data    = DF.data,
        mapping = aes(
		x   = log(centrifuge),
		y   = num.embryonic.anthers / num.prepared.anthers,
		col = storage
		)
        );

# Model 3
temp.x <- seq(3,6,0.1);
betas.hat <- coefficients(model3.glm);
betas.hat;
temp.y <- betas.hat[1] + betas.hat[2] * temp.x;
temp.y <- exp(temp.y) / (1 + exp(temp.y));
my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
	col     = 'black'
	);

# Model 2
betas.hat <- coefficients(model2.glm);
betas.hat;
temp.y <- betas.hat[1] + betas.hat[3] * temp.x;
temp.y <- exp(temp.y) / (1 + exp(temp.y));
my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
	col     = 'red'
	);

temp.y <- betas.hat[1] + betas.hat[2] +  betas.hat[3] * temp.x;
temp.y <- exp(temp.y) / (1 + exp(temp.y));
my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
	col     = 'red'
	);

# Model 1
betas.hat <- coefficients(model1.glm);
betas.hat;
temp.y <- betas.hat[1] + betas.hat[3] * temp.x;
temp.y <- exp(temp.y) / (1 + exp(temp.y));
my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
	col     = 'blue'
	);

temp.y <- betas.hat[1]+betas.hat[2] +  (betas.hat[3]+betas.hat[4]) * temp.x;
temp.y <- exp(temp.y) / (1 + exp(temp.y));
my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
	col     = 'blue'
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

