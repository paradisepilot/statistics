
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
	file = paste0(data.directory,'/tables-07-13-07-14-Adelaide-graduates.csv'),
	sep  = '\t'
	);
DF.data[,'p']        <- DF.data[,'survive'] / DF.data[,'total'];
DF.data[,'deceased'] <- DF.data[,'total'] - DF.data[,'survive'];
str(DF.data);
DF.data;

####################################################################################################
glm.full <- glm(
	formula = cbind(survive,deceased) ~ year + sex + faculty,
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(glm.full);

### (a) ############################################################################################
glm.noYear <- glm(
	formula = cbind(survive,deceased) ~ sex + faculty,
	data    = DF.data,
	family  = binomial(link = "logit")
	);
summary(glm.noYear);

anova(glm.noYear, glm.full, test = 'LRT');
anova(glm.noYear, glm.full, test = 'Chisq');

### (b) ############################################################################################
DF.temp <- DF.data[DF.data[,'sex'] %in% c('men'),];
summary(DF.temp);

glm.full <- glm(
	formula = cbind(survive,deceased) ~ year + faculty,
	data    = DF.temp,
	family  = binomial(link = "logit")
	);
summary(glm.full);

glm.noFaculty <- glm(
	formula = cbind(survive,deceased) ~ year,
	data    = DF.temp,
	family  = binomial(link = "logit")
	);
summary(glm.noFaculty);

anova(glm.noFaculty, glm.full, test = 'LRT');
anova(glm.noFaculty, glm.full, test = 'Chisq');

### (c) ############################################################################################
DF.temp <- DF.data[DF.data[,'sex'] %in% c('women'),];
summary(DF.temp);

glm.full <- glm(
	formula = cbind(survive,deceased) ~ year + faculty,
	data    = DF.temp,
	family  = binomial(link = "logit")
	);
summary(glm.full);

glm.noFaculty <- glm(
	formula = cbind(survive,deceased) ~ year,
	data    = DF.temp,
	family  = binomial(link = "logit")
	);
summary(glm.noFaculty);

anova(glm.noFaculty, glm.full, test = 'LRT');
anova(glm.noFaculty, glm.full, test = 'Chisq');

### (d) ############################################################################################
#DF.temp <- DF.data[DF.data[,'faculty'] %in% c('arts','science'),];
DF.temp <- DF.data;

glm.full <- glm(
	formula = cbind(survive,deceased) ~ year + sex * faculty,
	data    = DF.temp,
	family  = binomial(link = "logit")
	);
summary(glm.full);

glm.noInteraction <- glm(
	formula = cbind(survive,deceased) ~ year + sex + faculty,
	data    = DF.temp,
	family  = binomial(link = "logit")
	);
summary(glm.noInteraction);

anova(glm.noInteraction, glm.full, test = 'LRT');

####################################################################################################
resolution      <- 100;
graphics.format <- 'png';

my.filename <- paste('exercise-07-03',graphics.format,sep='.');
my.ggplot <- ggplot();
#my.ggplot <- my.ggplot + ylim(-0.05,1.05);
set.seed(1234567);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = jitter(year, factor = 0.30), y = p, colour = faculty, shape = sex),
	alpha   = 0.7
	);

betas <- coefficients(glm.full);
betas;

temp.x         <- seq(1938,1947,0.1);
temp.intercept <- betas['(Intercept)'] + betas['sexwomen'] + betas['facultyscience'] + betas['sexwomen:facultyscience'];
temp.slope     <- betas['year'];
temp.y         <- temp.intercept + temp.slope * temp.x;
temp.y         <- exp(temp.y) / (1 + exp(temp.y));

my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
        col     = 'purple'
        );

temp.intercept <- betas['(Intercept)'] + betas['sexwomen'];
temp.slope     <- betas['year'];
temp.y         <- temp.intercept + temp.slope * temp.x;
temp.y         <- exp(temp.y) / (1 + exp(temp.y));

my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
        col     = 'pink'
        );

temp.intercept <- betas['(Intercept)'] + betas['facultymedicine'];
temp.slope     <- betas['year'];
temp.y         <- temp.intercept + temp.slope * temp.x;
temp.y         <- exp(temp.y) / (1 + exp(temp.y));

my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
        col     = 'blue',
	lty     = 2
        );

temp.intercept <- betas['(Intercept)'] + betas['facultyengineering'];
temp.slope     <- betas['year'];
temp.y         <- temp.intercept + temp.slope * temp.x;
temp.y         <- exp(temp.y) / (1 + exp(temp.y));

my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
        col     = 'green',
	lty     = 2
        );

temp.intercept <- betas['(Intercept)'];
temp.slope     <- betas['year'];
temp.y         <- temp.intercept + temp.slope * temp.x;
temp.y         <- exp(temp.y) / (1 + exp(temp.y));

my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
        col     = 'pink',
	lty     = 2
        );

temp.intercept <- betas['(Intercept)'] + betas['facultyscience'];
temp.slope     <- betas['year'];
temp.y         <- temp.intercept + temp.slope * temp.x;
temp.y         <- exp(temp.y) / (1 + exp(temp.y));

my.ggplot <- my.ggplot + geom_line(
        data    = data.frame(x = temp.x, y = temp.y),
        mapping = aes(x = x, y = y),
        col     = 'purple',
	lty     = 2
        );

ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        #height = 0.5 * par("din")[1],
	width  = 12,
        dpi    = resolution,
        units  = 'in'
        );

####################################################################################################

q();

