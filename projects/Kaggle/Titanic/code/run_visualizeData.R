
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
temp <- as.data.frame(summarise(
	titanic.byClassSex,
	count    = n(),
	survived = sum(Survived, na.rm = TRUE),
	survivalRate = survived / count
	));

str  ( temp );
print( temp );

###################################################

q();

