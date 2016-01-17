
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);

source(paste0(code.directory,'/cleanThings.R'));
source(paste0(code.directory,'/denormalizeData.R'));
source(paste0(code.directory,'/doPrimaryForeignKeyDiagnostics.R'));
source(paste0(code.directory,'/getGeocodes.R'));
source(paste0(code.directory,'/getYouvilleData.R'));

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
doPrimaryForeignKeyDiagnostics(
	table.directory = table.directory,
	tmp.directory   = tmp.directory
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
denormalized.data <- denormalizeData(
	table.directory = table.directory,
	tmp.directory   = tmp.directory
	);

temp <- denormalized.data[['depositItems']];
#temp[temp[,'DepositItem'] %in% c(8326,8327,8328,8329),];
temp[temp[,'DepositItem'] %in% c(8326),];

###################################################

q();

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

