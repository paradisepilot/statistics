
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(ggmap);
library(RColorBrewer);
#library(VennDiagram);

source(paste0(code.directory,'/denormalizeDepositItems.R'));
source(paste0(code.directory,'/doPrimaryForeignKeyDiagnostics.R'));
source(paste0(code.directory,'/filterRegroup.R'));
source(paste0(code.directory,'/getGeocodes.R'));
source(paste0(code.directory,'/getYouvilleData.R'));
source(paste0(code.directory,'/plottingFunctions.R'));
source(paste0(code.directory,'/utils.R'));

setwd(output.directory);

###################################################
resolution <- 300;

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FILE.geocodes <- paste0(table.directory,'/geocodes.txt');
DF.geocodes <- read.csv(
	file = FILE.geocodes,
	sep  = "\t",
	stringsAsFactors = FALSE
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
LIST.depositItems <- denormalizeDepositItems(
	table.directory = table.directory,
	  tmp.directory =   tmp.directory,
	DF.geocodes     = DF.geocodes
	);
str(LIST.depositItems);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
retained.columns <- c(
	'ContactTypeMain',
	'AccountCode',
	'AccountName',
	'Amount'
	);

depositItems <- LIST.depositItems[['denormalized.depositItems']];
DF.temp <- depositItems[,retained.columns];

nrow(DF.temp);

sum(DF.temp[,'Amount'] == 0);

sum(DF.temp[,'Amount'] > 0);

sum(DF.temp[,'Amount'] < 0);

is.na.AccountCode <- is.na(DF.temp[,'AccountCode']);
sum(is.na.AccountCode);
DF.temp[is.na.AccountCode,];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
retained.columns <- c(
	'AccountCode',
	'AccountName',
	'Amount'
	);

DF.temp <- depositItems[,retained.columns];
DF.temp <- DF.temp[DF.temp[['Amount']]>0,];

by.AccountCode <- group_by(DF.temp,AccountCode,AccountName);
DF.temp <- summarize(by.AccountCode,
	sum.Amount    = sum(Amount),
	nDepositItems = n()
	);
DF.temp <- as.data.frame(DF.temp);

excluded.AccountCodes <- c(2011,4001,4002,4005);
DF.temp[(DF.temp[,'AccountCode'] %in% excluded.AccountCodes),];

DF.temp <- DF.temp[!(DF.temp[,'AccountCode'] %in% excluded.AccountCodes),];
DF.temp <- DF.temp[order(DF.temp[,'sum.Amount'],decreasing=TRUE),];
DF.temp <- cbind(
	DF.temp,
	percent = round(DF.temp[,'sum.Amount'] / sum(DF.temp[!is.na(DF.temp[,'sum.Amount']),'sum.Amount']),digits=6)
	);
DF.temp <- cbind(DF.temp,cumul.percent = cumsum(DF.temp[,'percent']));

str(DF.temp);

is.4000s <- (3999.9999 < DF.temp[,'AccountCode'] & DF.temp[,'AccountCode'] < 5000);
DF.temp[ is.4000s,setdiff(colnames(DF.temp),c('sum.Amount','nDepositItems'))];
DF.temp[!is.4000s,setdiff(colnames(DF.temp),c('sum.Amount','nDepositItems'))];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- depositItems[,retained.columns];
DF.temp <- DF.temp[DF.temp[['Amount']]<0,];

by.AccountCode <- group_by(DF.temp,AccountCode,AccountName);
DF.temp <- summarize(by.AccountCode,
	sum.Amount    = sum(Amount),
	nDepositItems = n()
	);
DF.temp <- as.data.frame(DF.temp);
DF.temp <- DF.temp[order(DF.temp[,'sum.Amount']),];
DF.temp <- cbind(
	DF.temp,
	percent = round(DF.temp[,'sum.Amount'] / sum(DF.temp[!is.na(DF.temp[,'sum.Amount']),'sum.Amount']),digits=6)
	);

str(DF.temp);
DF.temp[,setdiff(colnames(DF.temp),'AccountCode')];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
retained.columns <- c(
	'ContactTypeMain',
	'AccountCode',
	'AccountName',
	'Amount'
	);

DF.temp  <- depositItems[,retained.columns];
DF.temp  <- DF.temp[DF.temp[['Amount']]>0,];
is.4000s <- (3999.9999 < DF.temp[,'AccountCode'] & DF.temp[,'AccountCode'] < 5000);
DF.temp  <- DF.temp[is.4000s,];

byVars <- group_by(DF.temp,ContactTypeMain,AccountCode,AccountName);
DF.temp <- summarize(byVars,
	sum.Amount    = sum(Amount),
	nDepositItems = n()
	);
DF.temp <- as.data.frame(DF.temp);
DF.temp <- DF.temp[order(DF.temp[,'sum.Amount'],decreasing=TRUE),];
DF.temp <- cbind(
	DF.temp,
	percent = round(DF.temp[,'sum.Amount'] / sum(DF.temp[!is.na(DF.temp[,'sum.Amount']),'sum.Amount']),digits=6)
	);
DF.temp <- cbind(DF.temp,cumul.percent = cumsum(DF.temp[,'percent']));

DF.temp[DF.temp[,'AccountCode'] %in% c(4001,4002,4005,4013),];

DF.temp[! (DF.temp[,'AccountCode'] %in% c(4001,4002,4005,4013)),];

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- filterRegroup(DF.input = depositItems);

retained.columns <- c(
	'depositItem.group',
	'Amount'
	);
DF.temp  <- DF.temp[,retained.columns];

byVars <- group_by(DF.temp,depositItem.group);
DF.temp <- summarize(byVars,
	sum.Amount    = sum(Amount),
	nDepositItems = n()
	);
DF.temp <- as.data.frame(DF.temp);
DF.temp <- DF.temp[order(DF.temp[,'sum.Amount'],decreasing=TRUE),];
DF.temp <- cbind(
	DF.temp,
	percent = round(DF.temp[,'sum.Amount'] / sum(DF.temp[!is.na(DF.temp[,'sum.Amount']),'sum.Amount']),digits=6)
	);
DF.temp <- cbind(DF.temp,cumul.percent = cumsum(DF.temp[,'percent']));

DF.temp;

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

q();

