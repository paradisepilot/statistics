
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
#titanic.byClassSex <- group_by(DF.titanic,Sex,Pclass);
temp <- as.data.frame(summarise(
	titanic.byClassSex,
	count    = n(),
	survived = sum(Survived, na.rm = TRUE),
	survivalRate = survived / count
	));

str  ( temp );
print( temp );

model.poisson <- glm(
	data    = temp,
	formula = survived ~ Sex + Pclass,
	family  = poisson,
	offset  = count
	);

str(model.poisson);

cbind(temp,fitted=model.poisson[['fitted.values']]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- titanic.byClassSex[,c('Survived','Sex','Pclass','AgeGroup')];
str(DF.temp);
DF.temp <- na.omit(DF.temp);
str(DF.temp);

model.logistic <- glm(
	data    = DF.temp,
	formula = Survived ~ Sex + Pclass + AgeGroup,
	family  = binomial(link = logit)
	);

temp <- unique(cbind(
	DF.temp[,c('Sex','Pclass','AgeGroup')],
	fitted = model.logistic[['fitted.values']]
	));
arrange(temp,Sex,Pclass,AgeGroup);

###################################################

q();

