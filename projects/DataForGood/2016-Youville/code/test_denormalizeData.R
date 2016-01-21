
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
resolution <- 300;
zoom <- 12;

load(paste0(table.directory,"/ggmap-ottawa-zoom",zoom,".RData"));
str(ggmap.ottawa);

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
str(denormalized.depositItems);
str(denormalized.donationReceipts);

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- denormalized.donationReceipts[['denormalized.donationReceipts']];
DF.temp <- DF.temp[,c('DonationReceiptDate','DonationReceiptDonationAmount','ContactTypeMain')];
DF.temp[,'ContactTypeMain'] <- as.character(DF.temp[,'ContactTypeMain']);
DF.temp[is.na(DF.temp[,'ContactTypeMain']),'ContactTypeMain'] <- "unknown";
DF.temp[,'ContactTypeMain'] <- as.factor(DF.temp[,'ContactTypeMain']);
summary(DF.temp);

my.ggplot <- ggplot(data = NULL);
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(x = DonationReceiptDate, y = log10(DonationReceiptDonationAmount), color = ContactTypeMain),
	alpha   = 0.2
	);
my.ggplot <- my.ggplot + scale_x_date(
	date_labels        = "%b %Y",
	limits             = c(as.Date("1996-1-1"),as.Date("2015-12-31")),
	date_breaks        = "1 year"
	);
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,5.5));
my.ggplot <- my.ggplot + xlab("");
my.ggplot <- my.ggplot + ylab("log10(Donation Receipt : Donation Amount)");
my.ggplot <- my.ggplot + theme(
	title           = element_text(size = 20),
	axis.title      = element_text(size = 20),
	axis.text.x     = element_text(size = 15, angle = 90),
	axis.text.y     = element_text(size = 25),
	legend.position = "bottom",
	legend.text     = element_text(size = 15)
	);


temp.filename <- 'Youville-donation-amount-by-time.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
my.ggmap <- ggmap(ggmap = ggmap.ottawa, extent="device");
my.ggmap <- my.ggmap + geom_point(
	data   = denormalized.donationReceipts[['denormalized.donationReceipts']],
	colour = "red",
	alpha  = 0.3,
	mapping = aes(
		x     = DonationReceiptLongitude,
		y     = DonationReceiptLatitude,
		size  = DonationReceiptDonationAmount,
		color = ContactTypeMain
		)
	);

temp.filename <- 'Youville-donor-map.png';
ggsave(file = temp.filename, plot = my.ggmap, dpi = resolution, height = 8, width = 12, units = 'in');

###################################################

q();

