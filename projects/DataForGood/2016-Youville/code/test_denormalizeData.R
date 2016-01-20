
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
#ggmap.ottawa <- get_map("ottawa", zoom = 12, source = "google", maptype = "roadmap");

#ggmap.ottawa <- get_map("ottawa", zoom = 15);
#save(list = c("ggmap.ottawa"), file = "ggmap-ottawa-zoom15.RData");

#load("ggmap-ottawa.RData");
#load("ggmap-ottawa-zoom10.RData");
#load("ggmap-ottawa-zoom14.RData");
load("ggmap-ottawa-zoom15.RData");

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FILE.geocodes <- paste0(table.directory,'/geocodes.txt');
DF.geocodes <- read.csv(
	file = FILE.geocodes,
	sep  = "\t",
	stringsAsFactors = FALSE
	);

doPrimaryForeignKeyDiagnostics(
	table.directory = table.directory,
	tmp.directory   = tmp.directory,
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
str(denormalized.donationReceipts);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- denormalized.donationReceipts[['denormalized.donationReceipts']];

summary(
	DF.temp[,c('DonationReceiptDate','DonationReceiptDonationAmount')]
	);

#DF.temp[,'log10_DonationReceiptDonationAmount'] <- log10(DF.temp[,'DonationReceiptDonationAmount']);

my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = DonationReceiptDate, y = log10(DonationReceiptDonationAmount))
	);
my.ggplot <- my.ggplot + scale_x_date(
	date_labels        = "%b %Y",
	limits             = c(as.Date("1996-1-1"),as.Date("2015-12-31")),
	date_breaks        = "1 year"
	#date_minor_breaks  = "6 months"
	);
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,5.5));

resolution <- 300;
temp.filename <- 'Youville-donation-amount-by-time.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

q();

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggmap <- ggmap(ggmap = ggmap.ottawa, extent="device");
my.ggmap <- my.ggmap + geom_point(
	data   = denormalized.donationReceipts[['denormalized.donationReceipts']],
	colour = "red",
	alpha  = 0.3,
	mapping = aes(
		x    = DonationReceiptLongitude,
		y    = DonationReceiptLatitude,
		size = DonationReceiptDonationAmount
		)
	);

resolution <- 600;
temp.filename <- 'ottawa-map.png';
ggsave(file = temp.filename, plot = my.ggmap, dpi = resolution, height = 8, width = 12, units = 'in');

q();

#str(ggmap.ottawa);

#my.ggmap <- ggmap(ggmap = ggmap.ottawa, extent="device");

#resolution <- 600;
#temp.filename <- 'ottawa-google-roodmap.png';
#ggsave(file = temp.filename, plot = my.ggmap, dpi = resolution, height = 8, width = 8, units = 'in');

###################################################

q();

