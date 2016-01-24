
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(ggmap);

source(paste0(code.directory,'/denormalizeDepositItems.R'));
source(paste0(code.directory,'/denormalizeDonationReceipts.R'));
source(paste0(code.directory,'/doPrimaryForeignKeyDiagnostics.R'));
source(paste0(code.directory,'/getGeocodes.R'));
source(paste0(code.directory,'/getYouvilleData.R'));
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
doPrimaryForeignKeyDiagnostics(
        table.directory = table.directory,
         tmp.directory  = tmp.directory,
        DF.geocodes     = DF.geocodes
        );

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
denormalized.donationReceipts <- denormalizeDonationReceipts(
	table.directory = table.directory,
	  tmp.directory =   tmp.directory,
	DF.geocodes     = DF.geocodes
	);

write.table(
	x         = denormalized.donationReceipts[['denormalized.donationReceipts']],
	file      = "denormalized-donationReceipts.csv",
	sep       = "|",
	quote     = TRUE,
	row.names = FALSE
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
denormalized.depositItems <- denormalizeDepositItems(
	table.directory = table.directory,
	  tmp.directory =   tmp.directory,
	DF.geocodes     = DF.geocodes
	);

write.table(
	x         = denormalized.depositItems[['denormalized.depositItems']],
	file      = "denormalized-depositItems.csv",
	sep       = "|",
	quote     = TRUE,
	row.names = FALSE
	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
str(denormalized.depositItems);
str(denormalized.donationReceipts);

