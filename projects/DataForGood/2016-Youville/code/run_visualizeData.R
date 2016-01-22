
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

###################################################

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
FILE.geocodes <- paste0(table.directory,'/geocodes.txt');
DF.geocodes <- read.csv(
	file = FILE.geocodes,
	sep  = "\t",
	stringsAsFactors = FALSE
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
DF.temp <- DF.temp[,c('ContactID','DonationReceiptDate','DonationReceiptDonationAmount','ContactTypeMain')];

DF.temp[,'ContactTypeMain'] <- as.character(DF.temp[,'ContactTypeMain']);
DF.temp[is.na(DF.temp[,'ContactTypeMain']),'ContactTypeMain'] <- "unknown";
DF.temp[,'ContactTypeMain'] <- as.factor(DF.temp[,'ContactTypeMain']);

by.ContactID <- group_by(DF.temp,ContactID,ContactTypeMain);
DF.temp <- mutate(by.ContactID,
	minDate     = min(DonationReceiptDate),
	maxDate     = max(DonationReceiptDate),
	totalAmount = sum(DonationReceiptDonationAmount)
	);
DF.temp <- unique(select(DF.temp,-DonationReceiptDate,-DonationReceiptDonationAmount));
DF.temp <- na.omit(DF.temp);

is.onetimer <- as.logical(DF.temp[,'minDate'] == DF.temp[,'maxDate']);
DF.temp[is.onetimer,'maxDate'] <- DF.temp[is.onetimer,'maxDate'] - sample(
	x=500:2000,size=sum(is.onetimer),replace=TRUE
	);

str(DF.temp);

write.table(
	x         = DF.temp,
	file      = "Youville-donorRetention.csv",
	sep       = "|",
	quote     = TRUE,
	row.names = FALSE
	);

my.ggplot <- ggplot(data = NULL) + theme_bw() + scale_color_brewer(name = "Method", palette = "Set1");
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(
		x     = minDate,
		y     = maxDate,
		size  = totalAmount,
		color = ContactTypeMain
		),
	alpha = 0.2
	);

my.ggplot <- my.ggplot + geom_abline(intercept = 0, slope = 1, size = 1, linetype = 2, colour = "gray");

my.ggplot <- my.ggplot + scale_x_date(
	date_labels        = "%b %Y",
	limits             = c(as.Date("1996-07-01"),as.Date("2015-12-31")),
	date_breaks        = "1 year"
	);
my.ggplot <- my.ggplot + scale_y_date(
	date_labels        = "%b %Y",
	limits             = c(as.Date("1996-07-01"),as.Date("2015-12-31")),
	date_breaks        = "1 year"
	);

my.ggplot <- my.ggplot + xlab(      "First Donation Date");
my.ggplot <- my.ggplot + ylab("Most Recent Donation Date");

my.ggplot <- my.ggplot + theme(
	title            = element_text(size = 20, face = "bold"),
	axis.title       = element_text(size = 22, face = "bold"),
	axis.text.x      = element_text(size = 10, angle = 90),
	axis.text.y      = element_text(size = 10),
	panel.grid.major = element_line(size = 0.5),
	panel.grid.minor = element_line(size = 1.0),
	legend.position  = "right",
	legend.title     = element_blank(),
	legend.text      = element_text(size = 16, face = "bold")
	);

temp.filename <- 'Youville-donorRetention.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 14, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- denormalized.donationReceipts[['denormalized.donationReceipts']];
DF.temp <- DF.temp[,c('DonationReceiptDate','DonationReceiptDonationAmount','ContactTypeMain')];

DF.temp[,'ContactTypeMain'] <- as.character(DF.temp[,'ContactTypeMain']);
DF.temp[is.na(DF.temp[,'ContactTypeMain']),'ContactTypeMain'] <- "unknown";
DF.temp[,'ContactTypeMain'] <- as.factor(DF.temp[,'ContactTypeMain']);
DF.temp <- arrange(DF.temp,ContactTypeMain,DonationReceiptDate);

by.ContactTypeMain <- group_by(DF.temp,ContactTypeMain);
DF.temp <- mutate(by.ContactTypeMain, cumulAmount = cumsum(DonationReceiptDonationAmount));
str(DF.temp);

my.ggplot <- ggplot(data = NULL) + theme_bw() + scale_color_brewer(name = "Method", palette = "Set1");
my.ggplot <- my.ggplot + geom_step(
	data    = DF.temp,
	mapping = aes(
		x        = DonationReceiptDate,
		y        = cumulAmount,
		color    = ContactTypeMain
		),
	size = 1
	);

my.ggplot <- my.ggplot + scale_x_date(
	date_labels        = "%b %Y",
	limits             = c(as.Date("1996-07-01"),as.Date("2015-12-31")),
	date_breaks        = "1 year"
	);
my.ggplot <- my.ggplot + xlab("");
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,2e6));
my.ggplot <- my.ggplot + ylab("cumulative (Donation Amount)");

my.ggplot <- my.ggplot + theme(
	title            = element_text(size = 20,  face = "bold"),
	axis.title       = element_text(size = 22,  face = "bold"),
	axis.text.x      = element_text(size = 15, angle = 90),
	axis.text.y      = element_text(size = 13),
	panel.grid.major = element_line(size = 0.5),
	panel.grid.minor = element_line(size = 1.0),
	legend.position  = "bottom",
	legend.title     = element_blank(),
	legend.text      = element_text(size = 16, face = "bold")
	);

temp.filename <- 'Youville-cumulDonationAmount.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
DF.temp <- denormalized.donationReceipts[['denormalized.donationReceipts']];
DF.temp <- DF.temp[,c('DonationReceiptDate','DonationReceiptDonationAmount','ContactTypeMain')];

DF.temp[,'ContactTypeMain'] <- as.character(DF.temp[,'ContactTypeMain']);
DF.temp[is.na(DF.temp[,'ContactTypeMain']),'ContactTypeMain'] <- "unknown";
DF.temp[,'ContactTypeMain'] <- as.factor(DF.temp[,'ContactTypeMain']);

summary(DF.temp);

my.ggplot <- ggplot(data = NULL) + theme_bw() + scale_color_brewer(name = "Method", palette = "Set1");
my.ggplot <- my.ggplot + geom_point(
	data    = DF.temp,
	mapping = aes(
		x     = DonationReceiptDate,
		y     = log10(DonationReceiptDonationAmount),
		color = ContactTypeMain
		),
	alpha   = 0.2
	);
my.ggplot <- my.ggplot + scale_x_date(
	date_labels        = "%b %Y",
	limits             = c(as.Date("1996-07-01"),as.Date("2015-12-31")),
	date_breaks        = "1 year"
	);
my.ggplot <- my.ggplot + scale_y_continuous(limits=c(0,5.5));
my.ggplot <- my.ggplot + xlab("");
my.ggplot <- my.ggplot + ylab("log10(Donation Receipt : Donation Amount)");
my.ggplot <- my.ggplot + theme(
	title            = element_text(size = 20,  face = "bold"),
	axis.title       = element_text(size = 20,  face = "bold"),
	axis.text.x      = element_text(size = 15, angle = 90),
	axis.text.y      = element_text(size = 25),
	panel.grid.major = element_line(size = 0.5),
	panel.grid.minor = element_line(size = 1.0),
	legend.position  = "bottom",
	legend.title     = element_blank(),
	legend.text      = element_text(size = 15, face = "bold")
	);

temp.filename <- 'Youville-donation-amount-by-time.png';
ggsave(file = temp.filename, plot = my.ggplot, dpi = resolution, height = 8, width = 16, units = 'in');

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###
zoom <- 12;

load(paste0(table.directory,"/ggmap-ottawa-zoom",zoom,".RData"));
str(ggmap.ottawa);

my.ggmap <- ggmap(ggmap = ggmap.ottawa, extent="device");
my.ggmap <- my.ggmap + geom_point(
	data   = denormalized.donationReceipts[['denormalized.donationReceipts']],
	colour = "red",
	alpha  = 0.1,
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

