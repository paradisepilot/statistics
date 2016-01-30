
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- normalizePath(command.arguments[1]);
code.directory   <- normalizePath(command.arguments[2]);
output.directory <- normalizePath(command.arguments[3]);
tmp.directory    <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(ggmap);
library(RColorBrewer);

source(paste0(code.directory,'/getDataTitanic.R'));
#source(paste0(code.directory,'/plottingFunctions.R'));
#source(paste0(code.directory,'/utils.R'));

setwd(output.directory);

###################################################
resolution <- 300;

###################################################
DF.titanic <- getDataTitanic(data.directory = data.directory);

str(DF.titanic);

titanic.byClassSex <- group_by(DF.titanic,Sex,Pclass,AgeGroup);
temp.summary <- as.data.frame(summarise(
	titanic.byClassSex,
	count    = n(),
	survived = sum(Survived, na.rm = TRUE),
	survivalRate = survived / count
	));

str  ( temp.summary );
print( temp.summary );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- titanic.byClassSex[,c('Survived','Sex','Pclass','AgeGroup')];

model.logistic <- glm(
	data    = DF.titanic,
	formula = Survived ~ Sex * Pclass + AgeGroup,
	family  = binomial(link = logit)
	);

summary(model.logistic);

temp <- unique(cbind(
	DF.titanic[,c('Sex','Pclass','AgeGroup')],
	fitted = model.logistic[['fitted.values']]
	));
temp <- arrange(temp,Sex,Pclass,AgeGroup);

left_join(
	x  = temp.summary,
	y  = temp,
	by = c('Sex','Pclass','AgeGroup')
	);

###################################################

q();

