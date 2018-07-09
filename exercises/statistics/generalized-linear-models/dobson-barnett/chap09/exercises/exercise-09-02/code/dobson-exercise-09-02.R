
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
	file = paste0(data.directory,'/table-09-13-car-insurance.csv'),
	sep  = '\t'
	);
DF.data[,'insurance.category'] <- as.factor(DF.data[,'insurance.category']);
DF.data[,'policy.holder.age']  <- as.factor(DF.data[,'policy.holder.age']);
DF.data[,'district']           <- as.factor(DF.data[,'district']);
str(DF.data);
DF.data;

### (a) ############################################################################################
DF.by.category <- aggregate(
	formula = cbind(num.claims,num.policies) ~ insurance.category,
	data    = DF.data[,c('insurance.category','num.claims','num.policies')],
	FUN     = sum
	);
DF.by.category[,'rate.of.claims'] <- DF.by.category[,'num.claims'] / DF.by.category[,'num.policies'];

DF.by.age <- aggregate(
	formula = cbind(num.claims,num.policies) ~ policy.holder.age,
	data    = DF.data[,c('policy.holder.age','num.claims','num.policies')],
	FUN     = sum
	);
DF.by.age[,'rate.of.claims'] <- DF.by.age[,'num.claims'] / DF.by.age[,'num.policies'];

DF.by.district <- aggregate(
	formula = cbind(num.claims,num.policies) ~ district,
	data    = DF.data[,c('district','num.claims','num.policies')],
	FUN     = sum
	);
DF.by.district[,'rate.of.claims'] <- DF.by.district[,'num.claims'] / DF.by.district[,'num.policies'];

DF.by.category;
DF.by.age;
DF.by.district;

resolution      <- 100;
graphics.format <- 'png';

my.filename <- paste('exercise-09-02a-category',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_bar(
	data    = DF.by.category,
	mapping = aes(x = insurance.category, y = rate.of.claims),
	alpha   = 0.9
	);

ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        #height = 0.5 * par("din")[1],
	width  = 12,
        dpi    = resolution,
        units  = 'in'
        );

my.filename <- paste('exercise-09-02a-age',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_bar(
	data    = DF.by.age,
	mapping = aes(x = policy.holder.age, y = rate.of.claims),
	alpha   = 0.9
	);

ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        #height = 0.5 * par("din")[1],
	width  = 12,
        dpi    = resolution,
        units  = 'in'
        );

my.filename <- paste('exercise-09-02a-district',graphics.format,sep='.');
my.ggplot <- ggplot();
my.ggplot <- my.ggplot + geom_bar(
	data    = DF.by.district,
	mapping = aes(x = district, y = rate.of.claims),
	alpha   = 0.9
	);

ggsave(
        file   = my.filename,
        plot   = my.ggplot,
        #height = 0.5 * par("din")[1],
	width  = 12,
        dpi    = resolution,
        units  = 'in'
        );

### (b) ############################################################################################
glm.results <- glm(
	formula = num.claims ~ offset(log(num.policies)) + insurance.category * policy.holder.age * district,
	data    = DF.data,
	family  = poisson
	);
summary(glm.results);

### (c) ############################################################################################
DF.temp <- DF.data;
DF.temp[,'insurance.category'] <- as.numeric(DF.temp[,'insurance.category']);
DF.temp[,'policy.holder.age']  <- as.numeric(DF.temp[,'policy.holder.age']);
glm.c <- glm(
	formula = num.claims ~ offset(log(num.policies)) + insurance.category + policy.holder.age + district,
	data    = DF.temp,
	family  = poisson
	);
summary(glm.c);

####################################################################################################

q();

