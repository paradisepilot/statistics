
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

ggmap.ottawa <- get_map("ottawa", zoom = 12, source = "google", maptype = "roadmap");
str(ggmap.ottawa);

my.ggmap <- ggmap(ggmap = ggmap.ottawa, extent="device");

resolution <- 600;
temp.filename <- 'ottawa-google-roodmap.png';
ggsave(file = temp.filename, plot = my.ggmap, dpi = resolution, height = 8, width = 8, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

q();

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
#doPrimaryForeignKeyDiagnostics(
#	table.directory = table.directory,
#	tmp.directory   = tmp.directory
#	);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
denormalized.donationReceipts <- denormalizeDonationReceipts(
	table.directory = table.directory,
	tmp.directory   = tmp.directory
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
	tmp.directory   = tmp.directory
	);

write.table(
	x         = denormalized.depositItems[['denormalized.depositItems']],
	file      = "denormalized-depositItems.csv",
	sep       = "|",
	quote     = TRUE,
	row.names = FALSE
	);

###################################################

q();

