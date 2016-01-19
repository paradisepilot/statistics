
command.arguments <- commandArgs(trailingOnly = TRUE);
table.directory   <- normalizePath(command.arguments[1]);
code.directory    <- normalizePath(command.arguments[2]);
output.directory  <- normalizePath(command.arguments[3]);
tmp.directory     <- normalizePath(command.arguments[4]);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
library(dplyr);
library(ggmap);

source(paste0(code.directory,'/cleanThings.R'));
source(paste0(code.directory,'/denormalizeDepositItems.R'));
source(paste0(code.directory,'/denormalizeDonationReceipts.R'));
source(paste0(code.directory,'/doPrimaryForeignKeyDiagnostics.R'));
source(paste0(code.directory,'/getGeocodes.R'));
source(paste0(code.directory,'/getYouvilleData.R'));

setwd(output.directory);

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
contacts <- read.table(
	file             = paste0(table.directory,"/Contacts.txt"),
	header           = TRUE,
	sep              = '|',
	stringsAsFactors = FALSE
	);

donation.receipts <- read.table(
	file             = paste0(table.directory,"/DonationReceipts.txt"),
	header           = TRUE,
	sep              = '|',
	stringsAsFactors = FALSE
	);
        
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
postal.codes <- sort(unique(c(
	unique(toupper(contacts[['PostalCode']])),
	unique(toupper(donation.receipts[['PostalCode']]))
	)));
str(postal.codes);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.geocodes <- get.geocodes(
	locations     = postal.codes[1:200],
	FILE.geocodes = "geocodes.txt"
	);
str(DF.geocodes);

###################################################

q();

